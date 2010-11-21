Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab0KUQeI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 11:34:08 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58302 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab0KUQeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 11:34:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=iWZGHeZ2xaypMkvqeTsh+i0pZIS67LyA5NlzKS/5bdj6LaCLW5KX80ijZu795GE0kk
         uQweHj1rPWuMkTaGvXTO0OeEBnOBsMvLjVQ6+owf0Bgz6Bed0aEw8zgxZL/Sav5QVPi+
         aStZPwPy8DKCeCVAZLSFT1bCZUkQfCDPNFXjs=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Tino Keitel <tino.keitel@tikei.de>
Subject: Re: DVI/EDID broken with Intel i945 graphics and 2.6.37-rc2
Date: Sun, 21 Nov 2010 17:33:58 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20101116184914.GA15794@mac.home>
In-Reply-To: <20101116184914.GA15794@mac.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011211733.59220.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 16 listopada 2010 o 19:49:14 Tino Keitel wrote:
> Hi,
> 
> 2.6.37-rc2 doesn't seem to detect the LCD connected via DVI on my Mac
> mini Core2 Duo with i945 graphics:
> 
> [drm] initialized overlay support
> No connectors reported connected with modes
> [drm] Cannot find any crtc or sizes - going 1024x768
> 
> The text console is just black, and X uses a bogus resolution
> (1152x864). The native resolution of the LCD is 1680x1050.
> 
> It works with 2.6.36.
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=23462
for your bug report, please add your address to the CC list in there, thanks!


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
