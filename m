Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab0HRP0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:26:42 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61597 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab0HRP0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:26:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=jduu47tBmfMtB4Cu/wbdvB4tMI4T8kQ6GsEhm8+szvAE+GRQDE+rrEmljOnBuKDUMT
         lnFsQ7GgnFM662v+YwEx2YEkWARBafpFylv8wGd93+m59DP0y08IIuq1LI6It/CXM0zd
         FI0JwFThcwmIgyI1aS53f8bwXLQmQQpeMGx6Q=
Date: Wed, 18 Aug 2010 17:26:27 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>, swetland@google.com,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: android-kernel memory reclaim x20 boost?
Message-ID: <20100818172627.7e38969f@varda>
In-Reply-To: <20100818151857.GA6188@barrios-desktop>
References: <20100818151857.GA6188@barrios-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, 19 Aug 2010 00:18:57 +0900
Minchan Kim <minchan.kim@gmail.com> escribió:

> Hello Android forks,
[ ... ]
> 
> I saw the advertisement phrase in this[1]. 
> 
> "Kernel Memory Management Boost: Improved memory reclaim by up to 20x, 
> which results in faster app switching and smoother performance 
> on memory-constrained devices."
> 
> But I can't find any code for it in android kernel git tree.

 Maybe the enhancements are on the Dalvik VM (shooting in the dark here) 

> If it's your private patch, could you explan what kinds of feature can enhance 
> it by up to 20x?
> 
> If it is really good, we can merge it to mainline. 
> 
> [1] http://developer.android.com/sdk/android-2.2-highlights.html
> 
