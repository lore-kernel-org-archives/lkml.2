Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab0GCSUs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 14:20:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59586 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962Ab0GCSUr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 14:20:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=dApY2cpXTIC/LsePuRMU5eFVD9MSzellRHxrIuT2IVGJAHX9Py3+jsxLtze2lGW+36
         5mtgEJBvS6kgbp0dGAc66BDB6LHaoDPgOwyrh38R1GjJ9av355HZgsZYkiKYRCuT7web
         ekL+b0/si++0pLBelnBciuRQr5hZx1CPAbMZA=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: werner@guyane.yi.org
Subject: Re: 2.6.35-rc2,3 -- Problem with PS2 keyboard and mouse driver
Date: Sat, 3 Jul 2010 20:20:42 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-git8; KDE/4.4.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <1278041650.12788@guyane.yi.org>
In-Reply-To: <1278041650.12788@guyane.yi.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201007032020.42502.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On piątek, 2 lipca 2010 o 05:34:10 werner@guyane.yi.org wrote:
> 2.6.35-rc2,3,3-git1 -- Problem with PS2 keyboard and mouse driver
> 
> That problem continues at -git6 .
> 
> Since 2.6.35-rc2 the USB keyboard driver don't work longer, on different
> mainboards and keyboards.
> 
> On 2.6.35-rc1 things still were (more or less) normal.
> 
> THIS IS AN ERROR WHICH ENTERED BETWEEN 2.6.35 -rc1 and -rc2 !!
> 
> werner landgraf

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16332
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
