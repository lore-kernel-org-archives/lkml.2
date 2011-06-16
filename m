Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276Ab1FPO1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:27:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51221 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758199Ab1FPO1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:27:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=K6J9UxBsJzUqJkCVSFDvr6ld07/J9+F9/QENDcp8+2TOIc8BmXA0yonEkgD+1oLU7t
         09oMlIba1mJpSwcFmXKN+QdeWwU92Y87x3pbAabBhvSNmApLMJO/sWVcvzOUXpYb13ge
         WyWszYk7QXDkSng5hY5BrZXfCxNTH0XLnI4jw=
Date: Thu, 16 Jun 2011 16:27:42 +0200
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.0-rc2: mei breaks suspend
Message-ID: <20110616162742.186c0267@susi.home.s3e.de>
In-Reply-To: <201106161224.32504.a.miskiewicz@gmail.com>
References: <20110616110256.0890dd37@susi.home.s3e.de>
	<201106161224.32504.a.miskiewicz@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 16 Jun 2011 12:24:32 +0200
schrieb Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>:

> On Thursday 16 of June 2011, Stefan Seyfried wrote:
> > [39736.728116] pci_pm_suspend(): mei_pci_suspend+0x0/0xc0 [mei] returns
> > 9999
> 
> https://lkml.org/lkml/2011/6/13/148

Thanks. I should start really reading all LKML mail again ;-P

I pinged Greg again, so that we'll get this for 3.0
-- 
Stefan Seyfried

Linux Consultant & Developer
B1 Systems GmbH
Osterfeldstraﬂe 7 / 85088 Vohburg / http://www.b1-systems.de
GF: Ralph Dehner / Unternehmenssitz: Vohburg / AG: Ingolstadt,HRB 3537
