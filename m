Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab1FPKYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 06:24:41 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:32953 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab1FPKYi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 06:24:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=o4lslg9hmREpmVuNZorCTTerBMfCaJLMS0YghxH4NShKAEg4ufYnq8N5u6rmLSOuy9
         YQnl1hCa5/W1UmXLkxvP+tOffyvaOCDDr0qoe9s5cRazQuO9J1H9I/Lhp2hAFv2S00Q2
         sbbq+zXU/pU6isxnaQOjBcGR8ylsHe1EqAgLU=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 3.0-rc2: mei breaks suspend
Date: Thu, 16 Jun 2011 12:24:32 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc2-00362-g3c25fa7-dirty; KDE/4.6.4; x86_64; ; )
Cc: Stefan Seyfried <stefan.seyfried@googlemail.com>
References: <20110616110256.0890dd37@susi.home.s3e.de>
In-Reply-To: <20110616110256.0890dd37@susi.home.s3e.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106161224.32504.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 of June 2011, Stefan Seyfried wrote:
> Hi,
> 
> having the "mei" driver loaded, which happened automatically on my
> ThinkPad X200s, successfully prevents any suspend efforts:
> 
> [39736.728116] pci_pm_suspend(): mei_pci_suspend+0x0/0xc0 [mei] returns
> 9999

https://lkml.org/lkml/2011/6/13/148

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
