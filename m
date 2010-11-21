Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab0KUQvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 11:51:53 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48373 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab0KUQvw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 11:51:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=s1BMXoJ4BBbFi0oe+hJVKZkBaZVUxPk5MRAkWleljVd5jgzGourVM894ZB4nl+8DUM
         OGx+iBwnICLcpMMpqTOEKBAA7nm1gUQDvp29gwQ9OreXxE2RBlhduso62FacFlW7zfDD
         nD6synYNDl1TZAOgRfuW7Flh0K8XeiqPDHuFs=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Patrick Schaaf <netdev@bof.de>
Subject: Re: 2.6.37-rc2 vs. 2.6.36 laptop backlight changes?
Date: Sun, 21 Nov 2010 17:51:47 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <1290001262.5727.2.camel@lat1>
In-Reply-To: <1290001262.5727.2.camel@lat1>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011211751.47288.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 17 listopada 2010 o 14:41:02 Patrick Schaaf wrote:
> Hi,
> 
> were there any changes between 2.6.36 and 2.6.37-rc2 that would affect
> laptop display backlight control?
> 
> I have a Dell Latitude D630 laptop, with Intel on-board graphics
> 
> 00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960
> Integrated Graphics Controller (rev 0c)
> 
> used docked in dual-monitor setup. System is openSUSE 11.3, X.Org X
> Server 1.8.0
> 
> I notice that after logging in, under 2.6.37-rc2, the backlight of the
> laptop display is dimmed down. Using the brightness keys can turn it
> back up again. Logging out and logging in again, dims it again.
> 
> I do not notice this with 2.6.36.
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=23472
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
