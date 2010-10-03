Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab0JCSdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 14:33:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47510 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab0JCSdR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 14:33:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=EgdAkthnCcBn16kD2R2vXDbY08ePWEnPpBuQJ6OnHwAvEgY23+anXclawXOOV5HCsr
         m9MT8Q+1KyziyDVhs9cguqzHM5OiE1SPaHW8/CSoKUB5F9f/ZCI+xyh6nwZpb4YUt9zF
         pUvk4ON08nscjnRA5guydncgIRT8eTj4RLsLw=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Heinz Diehl <htd@fritha.org>
Subject: Re: 2.6.36-rc6: modprobe Not tainted warning
Date: Sun, 3 Oct 2010 20:33:09 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20100930182516.GA15089@fritha.org>
In-Reply-To: <20100930182516.GA15089@fritha.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010032033.10295.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czwartek, 30 września 2010 o 20:25:16 Heinz Diehl wrote:
> Hi,
> 
> on my brand new Asus U45JC, I get the following while booting 2.6.36-rc6:
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=19632
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
