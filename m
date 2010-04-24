Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab0DXI7Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 04:59:25 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:58058 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab0DXI7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 04:59:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=i9NkiIQXcfyrBxyoTPRS4yUBT1nm3A9CMioqXto5Z9CFKwiatD/G+BMvy0wQQ1nzdn
         0CvJ/k54NOo4UAaF/RheJ3atNhyf1QRqF4E+Dvt0IOnBaM+M2uSv6UgxQFD82i/c62fJ
         xImTkUxl0UEUqvddeUWBUTLFt8UYAX25hAT64=
From: Pedro Francisco <pedrogfrancisco@gmail.com>
To: Maciej =?utf-8?q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: ath5k misbehaving affecting other kernel parts unrelated?
Date: Sat, 24 Apr 2010 09:59:16 +0100
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: me@bobcopeland.com, "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       mickflemm@gmail.com
References: <201004230806.13628.pedrogfrancisco@gmail.com> <20100423163703.GB11112@hash.localnet> <v2p55a4f86e1004230943j6b312cacpca585c80096375ea@mail.gmail.com>
In-Reply-To: <v2p55a4f86e1004230943j6b312cacpca585c80096375ea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004240959.16688.pedrogfrancisco@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've 2 GB RAM + 5GB swap (got fed up with hibernating not working sometimes), 
so no such errors.

A Sexta, 23 de Abril de 2010 17:43:59 Maciej Żenczykowski escreveu:
> Do you have more than ~2.5-3.5GB of ram (enough to make some ram
> non-32-bit-DMA-accessible) with swiotlb enabled,
> if such are you seeing "DMA: Out of SW-IOMMU space" kernel messages?
> 
