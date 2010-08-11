Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab0HKTZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 15:25:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55021 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab0HKTZG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 15:25:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e3L1SSB7BgyWg5axCUHPvwO04/0e2WSyKt/5iIrMn2PeU6tHPzeHHYLVxbyEygCwVB
         1g75OE+7eUXZ+AZ49LaA3PQn5VgWbHZQmriudr+3N0ihbyoTlq/Yhrbzc63MdUlcHDYa
         0Mz2lGcNGc9kOnm9gD06vnHTgg0YHM3mBYZ9Y=
MIME-Version: 1.0
In-Reply-To: <20100810044541.GA2817@linux.vnet.ibm.com>
References: <AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
	<alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm>
	<20100807061558.GA28087@thunk.org>
	<AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com>
	<20100808155719.GB3635@thunk.org>
	<AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
	<20100808213821.GD3635@thunk.org>
	<20100809112453.77210acc@lxorguk.ukuu.org.uk>
	<20100809181638.GI3026@linux.vnet.ibm.com>
	<20100809201822.441905f7@lxorguk.ukuu.org.uk>
	<20100810044541.GA2817@linux.vnet.ibm.com>
Date: Wed, 11 Aug 2010 22:25:04 +0300
Message-ID: <AANLkTing0RpAoYstVs1G5v-eZ0q6qGjrGiphUvBdOsaS@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        david@lang.hm, Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 7:45 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Mon, Aug 09, 2010 at 08:18:22PM +0100, Alan Cox wrote:
>> You are tightly linking suspend blockers with Android. If they were a
>> sensible general solution they would be generic not tied closely to
>> Android
>
> Android is certainly where suspend blockers originated, and is to the best
> of my knowledge is still the only platform that uses them.  But there is
> a first user of every new mechanism, and for some time that first user
> will by definition be the only user of that mechanism.  So the fact
> that Android is most probably the only user of suspend blockers does
> not prove anything about whether or not suspend blockers are sensible.

No, it's the fact that *nobody* else has said: hey, that looks like a
good idea, we should use that in our mobile platform (or any
platform).

-- 
Felipe Contreras
