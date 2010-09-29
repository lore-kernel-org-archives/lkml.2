Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0I2Ir3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 04:47:29 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52406 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab0I2Ir1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 04:47:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=OQdESlXrThbZfDJ294WMVpkBWBfxq8FiDTc80Glhom+enOIcXXOT/GNFAX3eXlsfX2
         U2K26G8yrHWuqso4+647WUFBISZxJdINkCgdQ7Wk+Vu2mNNdhYEj5BqoF8ftfF5PsX6W
         iRUZu/CJgidEQ2vTUzH4xBND17yHN92laiPSo=
MIME-Version: 1.0
In-Reply-To: <AANLkTim2zK1Sp77B5bXUaGzeKyYLt7242yfcO=BWGjnc@mail.gmail.com>
References: <1285519830-6826-1-git-send-email-rahul.ruikar@gmail.com>
	<AANLkTinLPw+2QqPzLZ7X0BfRsfvqz1eh2Ay7P4t_Na+2@mail.gmail.com>
	<AANLkTim2zK1Sp77B5bXUaGzeKyYLt7242yfcO=BWGjnc@mail.gmail.com>
Date: Wed, 29 Sep 2010 17:47:26 +0900
X-Google-Sender-Auth: tcfpNSYn1QQAqbfIXVdWukYo2y4
Message-ID: <AANLkTimGhbYkUEsG8pUxncy2p3bD6QYrgmbmJ16xtvOw@mail.gmail.com>
Subject: Re: [RESEND] pcmcia: vrc4173_cardu: Fix error path for
 pci_release_regions and pci_disable_device
From: Yuasa Yoichi <yuasa@linux-mips.org>
To: Rahul Ruikar <rahul.ruikar@gmail.com>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2010/9/29 Rahul Ruikar <rahul.ruikar@gmail.com>:
> anyone to review / accept ???
> I could not find any particular maintainer for this patch through
> "./scripts/get_maintainer.pl" except these 2 lists.

I reviewed it.
It's OK.

Yoichi
