Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab0KGHoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 02:44:17 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59654 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab0KGHoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 02:44:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=QBMAiUo2WjftS0vLQhGs/8R7F+S1H7LoQede3vRmYwR/hg2ZSxN8MSE+y33/6yjft4
         ZD8az9x7dZVbeitUogX5ZSh/N2d5/TJtDM39RvTcllTCHCgQFJeWXOZGLbeAmuzMIf4r
         xe4ire94Z8HQLMWA09Ykxrqc7LA3WKygFIq3g=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Ian Kumlien <pomac@demius.net>
Subject: Re: High [extra timer interrupt] count in powertop since 2.6.36
Date: Sun, 7 Nov 2010 08:44:10 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.1010310148450.24290@twilight.pomac.com>
In-Reply-To: <alpine.LNX.2.00.1010310148450.24290@twilight.pomac.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011070844.10643.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On niedziela, 31 października 2010 o 01:52:08 Ian Kumlien wrote:
> Hi,
> 
> I have been searching the list for anyone else seeing this,
> but i haven't found anything yet - Any ideas on how to debug?
> 
> From powertop:
> Top causes for wakeups:
>    84.7% (1673.3)   [extra timer interrupt]
> 
> Thats a little bit high in my opinion, for some reason it seems to be
> ignored since the actual number of wakeups seems to be ~367 or so.
> 
> Ideas? Suggestions?

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=22272
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
