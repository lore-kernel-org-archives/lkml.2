Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab2CDQOW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 11:14:22 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49299 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab2CDQOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 11:14:21 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of maciej.rutecki@gmail.com designates 10.213.9.146 as permitted sender) smtp.mail=maciej.rutecki@gmail.com; dkim=pass header.i=maciej.rutecki@gmail.com
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Christoph Lameter <cl@gentwo.org>
Subject: Re: 3.3.0-rc5: OOps in dql_completed (Broadcom tg3 driver)
Date: Sun, 4 Mar 2012 17:14:15 +0100
User-Agent: KMail/1.13.7 (Linux/3.3.0-rc4; KDE/4.6.5; x86_64; ; )
Cc: mcarlson@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.1203011505510.6685@router.home>
In-Reply-To: <alpine.DEB.2.00.1203011505510.6685@router.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201203041714.15084.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 1 marca 2012 o 22:13:25 Christoph Lameter wrote:
> Dell R620. 2x 2.9Ghz Sandybridge
> 
> Sadly I could only get a screenshot and the top of the dump has scrolled
> off the system.

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=42860
for your bug/regression report, please add your address to the CC list in 
there, thanks!

-- 
Maciej Rutecki
http://www.mrutecki.pl
