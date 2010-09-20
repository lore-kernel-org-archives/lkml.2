Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab0ITTQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:16:06 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62333 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757195Ab0ITTQD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:16:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=TCKEDGWdems0iFWWGhCaGVWHrjxU63DC445V7JWlZsEQTLDjt/39UpRu04CZcQlZsd
         olfYuleGlhYDQCeciCMgAT+oYN3Egd62Zp7tMw/PaCLJxIs3av+0dWYX2k1DtN+Wm0K/
         kSZ0xS1loz98XLyuUNL+5S7Eyn4btOhLecPAo=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: vaibhav agarwal <vaibhav_agrwal@yahoo.co.in>
Subject: Re: Kernel panic in 2.6.36-rc4 after suspend/resume
Date: Mon, 20 Sep 2010 21:15:56 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <809346.96921.qm@web137402.mail.in.yahoo.com>
In-Reply-To: <809346.96921.qm@web137402.mail.in.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009202115.56325.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sobota, 18 września 2010 o 11:25:50 vaibhav agarwal wrote:
> Hi,
> 
> I am using kernel 2.6.34-rc4 directly taken from kernel.org. After suspend
> to ram if I leave it for few hours and resume then kernel panic happens
> (screen of death). If I suspend and resume immediately then it works fine.
> 
> I have hand copied the message and attached in this mail. Let me know what
> other
> 
> information is needed from my side.
> I can file bug in kernel bugzilla if needed. As per kernel oops docs, I am
> sending a mail here.
> 
> (Its a intel Dual Core machine)
> 
> -vaibhav

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=18882
for your bug report, please add your address to the CC list in there, thanks!
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
