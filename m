Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab2CEBVD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 20:21:03 -0500
Received: from eastrmfepo103.cox.net ([68.230.241.215]:48582 "EHLO
	eastrmfepo103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab2CEBVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 20:21:01 -0500
X-Greylist: delayed 869 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Mar 2012 20:21:00 EST
X-CT-Class: Clean
X-CT-Score: 0.00
X-CT-RefID: str=0001.0A020202.4F541197.0009,ss=1,re=0.000,fgs=0
X-CT-Spam: 0
X-Authority-Analysis: v=1.1 cv=rjo5WUwnpMKkM7QV+J5wtXqdgiVGF6yn6WDE+icESxU=
 c=1 sm=1 a=Ffi6gNd-JsMA:10 a=G8Uczd0VNMoA:10 a=kj9zAlcOel0A:10
 a=BHlAUmCoheIYy1iOc6ZX5Q==:17 a=VwQbUJbxAAAA:8 a=kviXuzpPAAAA:8
 a=OLL_FvSJAAAA:8 a=h1SbR2qrNfMxsWNhYHkA:9 a=dlM01VWCtOUkyHZRkxEA:7
 a=CjuIK1q_8ugA:10 a=hmtJxZeZjnUA:10 a=4vB-4DCPJfMA:10
 a=BHlAUmCoheIYy1iOc6ZX5Q==:117
X-CM-Score: 0.00
Authentication-Results: cox.net; auth=pass (CRAM-MD5)
 smtp.auth=1i5t5.duncan@cox.net
Date: Sun, 4 Mar 2012 18:06:28 -0700
From: Duncan <1i5t5.duncan@cox.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Nikolai Kondrashov <spbnick@gmail.com>
Subject: Re: [Bug #42649] Regression 3.2 -> 3.3-rc1 commit b4b583d4
 inet/media keyboard: stuck "extra" keys
Message-ID: <20120304180628.5444b453@ws>
In-Reply-To: <alpine.LNX.2.00.1203042201220.23367@pobox.suse.cz>
References: <FNlNbnGKWLP.A.dME.3F9UPB@chimera>
	<hq7dqombK_C.A.UsF.mG9UPB@chimera>
	<alpine.LNX.2.00.1203042201220.23367@pobox.suse.cz>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Mar 2012 22:03:10 +0100 (CET)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Sun, 4 Mar 2012, Rafael J. Wysocki wrote:
> 
> > The following bug entry is on the current list of known regressions
> > from 3.2.

> > Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42649
> > Subject	: Regression 3.2 -> 3.3-rc1 commit b4b583d4
> > inet/media keyboard: stuck "extra" keys
> > Submitter	: Duncan <1i5t5.duncan@cox.net> 
> > Date	: 2012-01-24 18:18 (41 days old)
> > First-Bad-Commit:
> > http://git.kernel.org/linus/b4b583d4e9a5ff28c4a150bb25a4fff5cd4dfbbd
> 
> [ adding Nikolai to CC ]
> 
> Nikolai already submitted a fix for b4b583d4e here: 
> http://www.spinics.net/lists/linux-input/msg19542.html
> 
> I will be queuing that shortly, and will try to make sure that it
> makes it into 3.3 still (otherwise 3.3-stable).
> 
> Duncan, I'd be interested whether it fixes the issue you are
> reporting as well.

Just finished testing.  Confirming.

3.3-rc6 unpatched (still) bad,

3.3-rc6 with that patch applied, good.

-- 
Duncan - No HTML messages please, as they are filtered as spam.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
