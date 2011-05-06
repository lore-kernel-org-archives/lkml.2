Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab1EFACp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:02:45 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58689 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328Ab1EFACp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:02:45 -0400
Message-ID: <4DC33A9D.9090107@kernel.dk>
Date: Thu, 05 May 2011 18:02:37 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iosched: remove redundant sprintf
References: <20110504153807.GA30153@outflux.net>
In-Reply-To: <20110504153807.GA30153@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-04 09:38, Kees Cook wrote:
> After the anticipatory scheduler was dropped, there was no need to
> special-case the request_module string. As such, drop the redundant
> sprintf and stack variable.

Thanks, applied to for-2.6.40/core

-- 
Jens Axboe

