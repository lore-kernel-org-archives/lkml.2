Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab0GCU7X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 16:59:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50222 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780Ab0GCU7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 16:59:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] arch/tile: avoid erroneous error return for PTRACE_POKEUSR.
Date: Sat, 3 Jul 2010 22:59:15 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.90; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201007030217.o632HwSr004032@farm-0002.internal.tilera.com>
In-Reply-To: <201007030217.o632HwSr004032@farm-0002.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007032259.15993.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18SMVYRx/FUmTHaTh0jw0O7pvwfgu9ZPATCTLY
 n5c4tHmhebeUYzvvJ4mzhgUmYyG1PURIK19Af0q7cO6dNyHw5y
 vesLfadF0DoBAHWbFNtWQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 July 2010 20:17:52 Chris Metcalf wrote:
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
