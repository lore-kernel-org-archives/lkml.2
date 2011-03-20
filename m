Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab1CTSbA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 14:31:00 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41430 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1CTSa5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 14:30:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Ztvqj+jTNuiDa4TiTcK9fADeExfektGJOldS0fibw1lrx3upmSLKXIGg/IJ/CaqD7w
         ZtJw3jbNkmqtXQsrKtvy+GFP8+1yY7LLZy8IWVkaOsYH2mmaHosoF/7CLjLSwEmk84Zh
         gra3VGpUQiVgcb7LNWIJIfR5w3pvGtjn68flI=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Melchior FRANZ <melchior.franz@gmail.com>
Subject: Re: i915/kms regression after 2.6.38-rc8 (was: Re: Linux 2.6.38)
Date: Sun, 20 Mar 2011 19:30:51 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38; KDE/4.4.5; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <AANLkTi=_cZRNPU29+MJkt9u6zDSLo153CKqLqg1+t7O6@mail.gmail.com> <201103161830.52231@rk-nord.at>
In-Reply-To: <201103161830.52231@rk-nord.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103201930.51911.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 16 marca 2011 o 18:30:51 Melchior FRANZ wrote:
> On my i915 using Acer TravelMate 5735z I could run kernel 2.6.38-rc8
> with KMS. On 2.6.38 I get a black screen instead. In case anyone
> cares, just tell me what information you need. (bisect result on
> request, but I assume the experts know which patch caused it.)
> 
> m.

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=31522
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
