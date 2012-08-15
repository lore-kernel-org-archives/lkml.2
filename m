Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab2HONpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:45:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51036 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab2HONpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:45:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 05/31] arm64: MMU initialisation
Date: Wed, 15 Aug 2012 13:45:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-6-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-6-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151345.08961.arnd@arndb.de>
X-Provags-ID: V02:K0:bmkZx/2G7MNVmrePERbjhUkordmP5WJdSKsJsHYFLIy
 OJkA2NsbCOd2UXzF6saofL3w6ywSAH3pcx03qRRHt5PjVtghO/
 JDkdQwc+GSA/3/0mTrBCkSRi1xUsQNnP3FVWpgrvZZhfIBmV1t
 p/PICV9mhvSeS4g41Za+VIxaYY3FlH66wYZ50p41zBLGJonI3N
 Q0ATQT7h9zoITGZCH3ASOIkHlvygG9DWd4Y/vM7Or2+ZAY4VaD
 Gc2j1joJaTH4thQtbjRPyM3Wuqw2somA7Ti8/HUKPy0msCIrv8
 gja1gWe+sR13nfX1RqghU+wxm9QsshrZVjSJxTTfMsyLVONMqX
 lhoT2riPARllFbp7V6r4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:
> This patch contains the initialisation of the memory blocks, MMU
> attributes and the memory map. Only five memory types are defined:
> Device nGnRnE (equivalent to Strongly Ordered), Device nGnRE (classic
> Device memory), Device GRE, Normal Non-cacheable and Normal Cacheable.
> Cache policies are supported via the memory attributes register
> (MAIR_EL1) and only affect the Normal Cacheable mappings.

It looks like you've managed to eliminate bootmem as I suggested earlier,
very nice!

Acked-by: Arnd Bergmann <arnd@arndb.de>

	Arnd
