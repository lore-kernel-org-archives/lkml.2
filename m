Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062Ab1D0OGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:06:51 -0400
Received: from sh.osrg.net ([192.16.179.4]:51025 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933008Ab1D0OGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:06:44 -0400
Date: Wed, 27 Apr 2011 23:06:00 +0900
To: catalin.marinas@arm.com
Cc: arnd@arndb.de, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] ARM DMA mapping TODO, v1
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <BANLkTinPbZZS9F1tRCA73fgoD-y__jSfCA@mail.gmail.com>
References: <201104212129.17013.arnd@arndb.de>
	<BANLkTinPbZZS9F1tRCA73fgoD-y__jSfCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110427230344I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 27 Apr 2011 23:06:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 10:52:25 +0100
Catalin Marinas <catalin.marinas@arm.com> wrote:

> Anyway, we end up with different DMA ops per device via dev_archdata.

Several architectures already do. What's wrong with the approach for
arm?
