Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab0HHRIf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 13:08:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32860 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab0HHRIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 13:08:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=M8opkRbuGB93LxXDb8T0TeE9BSy4BXLbY8WYgS5vLxk6fnq9SHF0jFiUH2SLbPHkkD
         WaCgoXKxjybLn2VW504qYw+I+O7Ew5bm4TjbJJs6eZX3wVOAJwMMLFynR2tHIY5xWA1d
         zMBNva68B8xRV9JB+aXqYnq6sBUilB662Yapw=
MIME-Version: 1.0
In-Reply-To: <20100808160810.GA7968@srcf.ucam.org>
References: <alpine.DEB.2.00.1008051800360.25170@asgard.lang.hm>
	<20100806123047.GE31326@sirena.org.uk>
	<20100806172226.GH2432@linux.vnet.ibm.com>
	<20100806173325.GA25367@rakim.wolfsonmicro.main>
	<20100806181832.GJ2432@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008061517130.30564@asgard.lang.hm>
	<20100807001431.GA3252@opensource.wolfsonmicro.com>
	<alpine.DEB.2.00.1008061741460.30564@asgard.lang.hm>
	<20100807062828.GB28087@thunk.org>
	<AANLkTinTfKRfAUJqggcK9Cgo9BTXfqMjJ2SXZS=D1bmT@mail.gmail.com>
	<20100808160810.GA7968@srcf.ucam.org>
Date: Sun, 8 Aug 2010 20:08:33 +0300
Message-ID: <AANLkTik3FN5tTO8sgwz32b8s2SLnc8D1=14yU-a2betp@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, david@lang.hm,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Brian Swetland <swetland@google.com>,
        kevin granade <kevin.granade@gmail.com>,
        "Arve Hj?nnev?g" <arve@android.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 8, 2010 at 7:08 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Sun, Aug 08, 2010 at 04:35:13PM +0300, Felipe Contreras wrote:
>
>> appropriately; that's not the case.
>>
>> 1) Install a bad application that requests PM permissions and is granted those
>>
>> In this case you've gained nothing with user-space suspend blockers.
>
> It's clearly possible for a pathological Android application to destroy
> the power management policy. But to do that, the author would have to
> explicitly take a wakelock. That's difficult to do by accident.

The writer can take a wakelock the whole time the application is
running (isn't that the typical case?), because perhaps the author
realizes that way the application works correctly, or he copy-pasted
it from somewhere else.

-- 
Felipe Contreras
