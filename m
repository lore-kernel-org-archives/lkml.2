Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934563Ab0HMP23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 11:28:29 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56779 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934495Ab0HMP22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 11:28:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h5VpXMDJ2zQVPAfdtaOwwQFJ3w/FcS/2uYW1YiSUG/zWxfBI0KN1m86pDdklmU0zlV
         pbRcvFbgpCw22cFOKPUCISbme+3Gee77UN8jIvv/lKJ8wqqgjAyUVwmnt+h7Iykn6+v0
         w12Diue9lzPIUHwkSY89dLQ63cED1uWnz1Dpg=
MIME-Version: 1.0
In-Reply-To: <20100813151451.GC2511@linux.vnet.ibm.com>
References: <20100809181638.GI3026@linux.vnet.ibm.com>
	<20100809201822.441905f7@lxorguk.ukuu.org.uk>
	<20100810044541.GA2817@linux.vnet.ibm.com>
	<20100810093849.138e2318@lxorguk.ukuu.org.uk>
	<20100811004223.GH2379@linux.vnet.ibm.com>
	<AANLkTik7Po9OuKC-QBZ=E83J70sU_ewNi+nNWgcjjLXd@mail.gmail.com>
	<20100811221258.GI2516@linux.vnet.ibm.com>
	<AANLkTi=fJjM=uWeV+L66ajM9rhrL0t1OO-C7ThNRdbae@mail.gmail.com>
	<20100812161935.GC2524@linux.vnet.ibm.com>
	<AANLkTi=51cFa0t5ZYj2CMiauuW80ZWTrm1tQkn63Et0F@mail.gmail.com>
	<20100813151451.GC2511@linux.vnet.ibm.com>
Date: Fri, 13 Aug 2010 18:28:27 +0300
Message-ID: <AANLkTimGHYZ4ndznJY-vjBb164xMSiGMeoJs=9=baSFi@mail.gmail.com>
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

On Fri, Aug 13, 2010 at 6:14 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Thu, Aug 12, 2010 at 08:52:22PM +0300, Felipe Contreras wrote:
>>  4) no, we can't say anything about what opportunistic suspend means in practice
>
> Here I disagree.  The Android folks have used it for quite some time.
> We might not be able to apply their experience directly to other software
> stacks, but we should nevertheless be able to learn quite a bit from it.

So when it comes to practice you are relying solely on what Android people say.

If it's true that it's easy to spot the "PM-driving applications",
then it shouldn't be hard for a guy from the Android team to assemble
a basic typical system (X.org, dbus, etc.) with suspend-blockers in a
couple of days.

-- 
Felipe Contreras
