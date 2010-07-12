Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab0GLGje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 02:39:34 -0400
Received: from sh.osrg.net ([192.16.179.4]:54449 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316Ab0GLGjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 02:39:32 -0400
Date: Mon, 12 Jul 2010 15:39:22 +0900
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH] microblaze: remove unused HAVE_ARCH_PCI_SET_DMA_MASK
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100712153701V.fujita.tomonori@lab.ntt.co.jp>
References: <20100712153701V.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100712153906K.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 12 Jul 2010 15:39:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010 15:37:20 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> HAVE_ARCH_PCI_SET_DMA_MASK was removed in 2.6.36 (no architecture has

Oops, HAVE_ARCH_PCI_SET_DMA_MASK was removed in 2.6.34.
