Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473Ab0FPTee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 15:34:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42062 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759082Ab0FPTec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 15:34:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=j1MVOtMMs5GFf7nvunoR4bHN2SQr+K9WsISKz7DwmmC/0tUQ8Y6UqHFgvKsetQM5na
         VkepvUjDSU/QoV28YCch6eftNkaAw1JP9orEHiSoWYx3zXNtNO7YtoYVzPXwIjmFTjYM
         V6TRnu4GAIBYo0cCmguG1pD4m5JydAD/U3sb4=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: inconsistent IN-HARDIRQ-W -> HARDIRQ-ON-W usage: fasync, 2.6.35-rc3
Date: Wed, 16 Jun 2010 21:34:26 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3; KDE/4.4.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20100613095305.GA13231@comet.dominikbrodowski.net>
In-Reply-To: <20100613095305.GA13231@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006162134.27117.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On niedziela, 13 czerwca 2010 o 11:53:05 Dominik Brodowski wrote:
> Hi!
> 
> A pristine -rc3 kernel resulted in this warning:
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16230
for your bug report, please add your address to the CC list in there, thanks!
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
