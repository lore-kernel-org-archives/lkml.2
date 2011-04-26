Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab1DZOaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:30:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52481 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464Ab1DZOaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:30:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: KyongHo Cho <pullip.cho@samsung.com>
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Date: Tue, 26 Apr 2011 16:29:51 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Zach Pfeffer <zach.pfeffer@linaro.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Ilho Lee <ilho215.lee@samsung.com>, sanghyun75.lee@samsung.com
References: <201104212129.17013.arnd@arndb.de> <BANLkTim5umALqafjA2e88UCLzMp9LQu3_Q@mail.gmail.com> <BANLkTimz8zprEw7H_i8g2qj8RyyougiBBw@mail.gmail.com>
In-Reply-To: <BANLkTimz8zprEw7H_i8g2qj8RyyougiBBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104261629.51765.arnd@arndb.de>
X-Provags-ID: V02:K0:puaLHh/UejS+A79OzcNRWLztlL7u0BJQbn3F9WyiFkJ
 xEJFyuPcAJiuXVD6eCJZGbO9e5zNLLYPN+v9BXE1Opm3VNLY4h
 S3+2TW3V8nZX40Z0kpjlpjMsI/LKuWvHpGsJrp+RdRuHcDLN6W
 lbLMseb5AB+gR2jV72f33KvRaVmdcjVJ6XH1O8/xkfCXwGzUmu
 TzGGJJ4SLVMJJ0KMb15Jw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 April 2011, KyongHo Cho wrote:
> IOMMU api does not provide virtual memory management.
> DMA api is not flexible for all our use-cases.

We can fix either problem by changing the existing interfaces,
which is much more maintainable in the long run than adding
a third one.

	Arnd
