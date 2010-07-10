Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158Ab0GJT4h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 15:56:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57616 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab0GJT4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 15:56:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=S9ACqXm79WP2doDVK8RDPcS68dGSPDH7aDO+43+oHRnQtyFN80eTXHpAdOv5T18nfe
         PZ9CxICCAbzgeWU4riWz0YwF04hBCG5fsovZ46OFELzf9vmBHNVJs0NDDKj3Hh3J4YG1
         /UO4Owh/z3iKjWeXsczJ+o78Evp8/QBjCQiIY=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [BUG -tip bisected] x86, mem: Optimize memcpy by avoiding memory false dependece
Date: Sat, 10 Jul 2010 21:56:29 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc4; KDE/4.4.4; i686; ; )
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, Ma Ling <ling.ma@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20100707220325.GA27738@Krystal>
In-Reply-To: <20100707220325.GA27738@Krystal>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007102156.30347.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 8 lipca 2010 o 00:03:25 Mathieu Desnoyers wrote:
> Hi Ingo,
> 
> I just bisected the cause of boot hard lockup on my Intel Xeon E5405 to
> this commit recently added to -tip:
> 
> a1e5278e40f16a4611264f8da9e557c16cb6f6ed is the first bad commit
> Merge branch 'x86/mem'
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16364
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
