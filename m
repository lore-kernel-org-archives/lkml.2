Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab0DFOMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 10:12:37 -0400
Received: from relay.atmel.no ([80.232.32.139]:63456 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab0DFOMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 10:12:31 -0400
X-Greylist: delayed 1987 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Apr 2010 10:12:30 EDT
Date: Tue, 6 Apr 2010 15:38:08 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 02/12] avr32: use asm-generic/scatterlist.h
Message-ID: <20100406153808.05637d00@hskinnemoen-d830>
In-Reply-To: <1270511567-18567-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1270511567-18567-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Organization: Atmel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>

It's a bit difficult to review without context, but assuming this
doesn't make struct scatterlist any larger:

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
