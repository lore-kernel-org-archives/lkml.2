Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab0KHNn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 08:43:28 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46897 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803Ab0KHNn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 08:43:27 -0500
Message-ID: <4CD7FE82.7050701@fusionio.com>
Date: Mon, 08 Nov 2010 14:43:30 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] floppy: replace NO_GEOM macro with a function
References: <1289028939-9407-1-git-send-email-penberg@kernel.org>
In-Reply-To: <1289028939-9407-1-git-send-email-penberg@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-06 08:35, Pekka Enberg wrote:
> This patch replaces the NO_GEOM macro with a proper static inline function and
> converts an open-coded caller in check_floppy_change() to use it.

Thanks Pekka, applied to for-2.6.38/drivers

-- 
Jens Axboe

