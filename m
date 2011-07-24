Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab1GXSzq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 14:55:46 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:44504 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab1GXSzk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 14:55:40 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: =?iso-8859-1?q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
Subject: Re: BUG: unable to handle kernel paging request xfs_is_delayed_page
Date: Sun, 24 Jul 2011 20:55:36 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc4; KDE/4.6.4; i686; ; )
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4E289228.4000208@gmail.com> <201107240914.04145.maciej.rutecki@gmail.com> <4E2BFC9C.3060902@gmail.com>
In-Reply-To: <4E2BFC9C.3060902@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107242055.36446.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On niedziela, 24 lipca 2011 o 13:06:04 Török Edwin wrote:
> On 07/24/2011 10:14 AM, Maciej Rutecki wrote:
> > On czwartek, 21 lipca 2011 o 22:55:04 Török Edwin wrote:
> >> Hi,
> >> 
> >> Just got this BUG in my dmesg:
> >> [47504.938446] BUG: unable to handle kernel paging request at
> >> ffff884058ec3270 [47504.938488] IP: [<ffffffff8127baf1>]
> > 
> > [...]
> > 
> > 2.6.39 works OK?. It is regression?
> 
> I don't know, I was not able to reproduce the bug on 3.0 either.
> Either the bug was fixed between 3.0-rc7 and 3.0, or it is very hard to
> reproduce.

Thanks for the information. When if you confirm that is regression please 
report it (then I will create bug entry in bugzilla).

Regards

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
