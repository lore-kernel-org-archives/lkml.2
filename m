Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab0JUSWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 14:22:17 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49108 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801Ab0JUSWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 14:22:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=K6KxPNTvY7BhVwfQJItHPKwGo1h7Ted5mq41IuuWkTfl/oHxyg+hOah+HRmnXSNEOQ
         diwUn/NydqoOZMAgiOOhv8w4fk1NMa8V2KGQffsB94HzzHMVkqA3mvit9NHto7sAHfqz
         +H+sZxyzQJZmv3VQ+WsKAMwMxOaYPsiELQDjo=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: evogt@free.fr
Subject: Re: PROBLEM: kernel 2.6.35.7 crashes under I/O load
Date: Thu, 21 Oct 2010 20:22:09 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc8-git3; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <alpine.DEB.1.10.1010202300540.3989@coniglio.vogt-bodving.test>
In-Reply-To: <alpine.DEB.1.10.1010202300540.3989@coniglio.vogt-bodving.test>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010212022.09399.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 20 października 2010 o 23:20:27 Etienne Vogt wrote:
> Hi there !
> 
>   Since upgrading my main Linux Debian system to the last 2.6.35.7 kernel,
> it's suffering from frequent crashes under I/O load.
>   This evening, one of these crashes was recorded into the system logs.
> When it occured, I was processing a Digital TV recording with mencoder.

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=20892
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
