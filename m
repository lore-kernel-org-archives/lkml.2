Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab0KDTJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 15:09:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47193 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab0KDTJu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:09:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=ixXoJvmS5VXKDICsgw8Gw2brOVNrh2PzdFesZX6eR2dVc4X7ZP3abitbo5Jv8huo0f
         NGV5DJmyOsXov1e8ru5uFYks5XwP8TFIYB876MonhK5u2HWWbnGtbQWlAyktrTu88PZL
         Fwbrlq+HBHK+tIR9kb4rAQk9yjyotRp5Qo0Z8=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: Re: [2.6.36-09452-g2d10d87] BUG: unable to handle kernel NULL pointer dereference at (null)
Date: Thu, 4 Nov 2010 20:09:44 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1; KDE/4.4.5; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
References: <20101030200751.GA2866@Pilar.aei.mpg.de>
In-Reply-To: <20101030200751.GA2866@Pilar.aei.mpg.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011042009.44901.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sobota, 30 października 2010 o 22:07:51 Carlos R. Mafra wrote:
> I am testing Linus' git kernel from today 2.6.36-09452-g2d10d87
> and I get the following BUG: when I plug in the WinTV Nova-T USB
> stick to watch television:
> 
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=22102
for your bug report, please add your address to the CC list in there, thanks!


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
