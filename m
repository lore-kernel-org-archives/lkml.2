Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab1HDQHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 12:07:33 -0400
Received: from ip-67-205-80-138.static.privatedns.com ([67.205.80.138]:1949
	"EHLO node250.e-blokos.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755106Ab1HDQHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 12:07:31 -0400
X-Greylist: delayed 991 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Aug 2011 12:07:31 EDT
Message-ID: <7CE2C553CB934F9EB1F6E620F4C18974@e1705>
From: "Madovsky" <infos@madovsky.org>
To: "LKML" <linux-kernel@vger.kernel.org>
References: <1312465990.16729.22.camel@twins>
Subject: Re: [ANNOUNCE] 3.0-rt7
Date: Thu, 4 Aug 2011 11:50:52 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.6109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----- 
From: "Peter Zijlstra" <peterz@infradead.org>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>; "Paul E. McKenney" 
<paulmck@us.ibm.com>; "linux-rt-users" <linux-rt-users@vger.kernel.org>
Sent: Thursday, August 04, 2011 9:53 AM
Subject: [ANNOUNCE] 3.0-rt7


> Hi,
>
> With Thomas enjoying his well earned holidays, I hereby present you with
> 3.0-rt7.
>
> Goodies included since last time:
>
> - some raw_spinlock patch from Uwe.
> - cpupri rework from Rostedt, something which should greatly benefit
>   everybody with smp hardware, the more cpus the more benefit.
> - a possible fix for some posix timer splat reported by Fernando.
> - i386-highmem support because I'd already written the code anyway
>   so I thought I might as well make it work.
>
> I'll take patches implementing similar highmem muck on other arches, if
> there's any code to be shared between the arches, do so.
>
> Patches live at the usual location, single patch:
>
> http://www.kernel.org/pub/linux/kernel/projects/rt/patch-3.0-rt7.patch.bz2
>
> quilt series tarball:
>
> http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0-rt7.tar.bz2
>
> If your favourite patch isn't included, make sure it landed in my inbox,
> or better yet make it land there again.
>
> Known issues I still have to look at is some posix test fail from der
> Hofrat and the ever fun pile of CGROUP_RT.
>
> Enjoy!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Danke Peterz and Thomas !
will test it soon

Franck 

