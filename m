Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab0IVKGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 06:06:48 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33712 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484Ab0IVKGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 06:06:47 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: dave@gnu.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kmemleak: add unlikely() optimization to kmemleak_late_init
References: <1285089797.2177.2.camel@cowboy>
Date: Wed, 22 Sep 2010 11:06:35 +0100
In-Reply-To: <1285089797.2177.2.camel@cowboy> (Davidlohr Bueso's message of
	"Tue, 21 Sep 2010 13:23:17 -0400")
Message-ID: <tnxlj6uhz2s.fsf@e102109-lin.cambridge.arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 Sep 2010 10:06:38.0599 (UTC) FILETIME=[D8BD7170:01CB5A3D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davidlohr Bueso <dave@gnu.org> wrote:
> kmemleak: add unlikely() optimization to kmemleak_late_init()
>
> Since there it is not very probable that kmemleak_disable() was called right after setting kmemleak_initialized, we could benefit from predicting it.

The patch is correct and you can add my Acked-by but I don't really
think it's worth. We save ~2 cycles during booting, no-one would ever
notice.

-- 
Catalin
