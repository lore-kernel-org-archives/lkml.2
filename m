Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab1E2Txe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 15:53:34 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60624 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab1E2Txd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 15:53:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=dHlXF/05dLrHTrykOzkYi1XaBFM7NScNkRGu4mSBeOxColUMzAe7zlZbUz2DPoHddo
         vqvnMYI+eL1xepMNU+5DPYptDclQ7WDzFFyxVM/axcNtuFkVZb4sX6PLrGWbRcCcz8+O
         0OOpSaPGHWbWsoBk1cQW/I6Jq+3g7pGhg0CyI=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Olaf Freyer <aaron667@gmx.net>
Subject: Re: Erroneous package power limit notification since kernel 2.6.39
Date: Sun, 29 May 2011 21:53:27 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4DD9092A.4080507@gmx.net>
In-Reply-To: <4DD9092A.4080507@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105292153.27823.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On niedziela, 22 maja 2011 o 15:01:30 Olaf Freyer wrote:
> Hi,
> 
> since using kernel-2.6.39 I recieve those reports right after rebooting
> my system when it's still "warm".
> (Sensors reporting about 50°C. I don't see those on a cold boot early in
> the morning.)
> I don't get any such reports with 2.6.38.7 or any earlier kernel I used
> before.
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=36182
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
