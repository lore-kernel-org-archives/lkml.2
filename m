Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab0CRTxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 15:53:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51161 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab0CRTxu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 15:53:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 15559] Bad performance after suspend on Intel i7 and i5
Date: Thu, 18 Mar 2010 20:56:40 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: bugzilla-daemon@bugzilla.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <lenb@kernel.org>
References: <bug-15559-10028@http.bugzilla.kernel.org/> <201003181842.o2IIgUSL031098@demeter.kernel.org>
In-Reply-To: <201003181842.o2IIgUSL031098@demeter.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003182056.40655.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's an interesting issue, apparently Core i5 and i7 have problems after
resume from suspend/standby.

I wonder whom at Intel I should let know about that.

Rafael


On Thursday 18 March 2010, bugzilla-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=15559
> 
> 
> 
> 
> 
> --- Comment #3 from Thomas Bächler <thomas@archlinux.org>  2010-03-18 18:42:26 ---
> I have only tested 2.6.33 and 2.6.33.1, as this machine is quite new. Besides
> other unrelated suspend problems, I can always reproduce this one on a Core
> i5-520M, the symptoms are exactly the ones that Florian describes.
> 
> The diversity of hardware and different kernels here suggests that this is a
> general problem with the i5 and i7 CPUs on Linux. Also interesting is that
> Florian is using an i7 of the 2009 generation, while I use the 2010 i5 CPU and
> the bug is the same on both.
> 
> On the same kernel(s), my old Core 2 Duo CPU has no trouble after resume, all
> cores are still being used as usual.
> 
> If you need any more info, I think we will be able to provide anything you
> need. Maybe it might also be useful to bring someone from Intel in on this.
