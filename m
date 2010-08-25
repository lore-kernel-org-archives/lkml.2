Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab0HYSTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 14:19:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51589 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab0HYSTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 14:19:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=dN3/e9L0EU0OHb985c2vLWP+V710OIQdzMcqwKv9JXnOGb0Ywxxod2pbT/clXfoKf3
         IiX8/JViAqE/3K/UBB+YwAIPUB0+7nkO0UQw5UUio0Hk03ulfOwMqVXdfXoImM35AeN4
         asLBuhq5fflHUr5cBIdw1ibEYnHpiU0p1YnnM=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Bruno =?utf-8?q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Subject: Re: [2.6.36 regression] Under linux console gpm cursor now going to opposite direction of mouse
Date: Wed, 25 Aug 2010 20:19:01 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc1; KDE/4.4.5; i686; ; )
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100820223316.4f6ac734@neptune.home>
In-Reply-To: <20100820223316.4f6ac734@neptune.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008252019.02455.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On piątek, 20 sierpnia 2010 o 22:33:16 Bruno Prémont wrote:
> Somewhere between 2.6.35 and Linus's tree as of this writing gpm
> started moving its cursor to the opposite direction of mouse movement.
> 
> e.g. moving mouse up causes cursor to move down, moving mouse left
>      causes cursor to go right
> 
> Under 2.6.35 the cursor moved into the same direction as the mouse.
> 
> Note, mouse is synaptics touchpad (Acer TravelMate660):
>   Synaptics Touchpad, model: 1, fw: 5.8, id: 0x9d48b1, caps:
> 0x904713/0x4006/0x0
> 
> 
> When I get around to it I will try to get more precise information as
> to when this regression got introduced, eventually bisecting.
> 
> Bruno

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=17031
for your bug report, please add your address to the CC list in there, thanks!
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
