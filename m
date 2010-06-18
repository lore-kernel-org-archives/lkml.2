Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568Ab0FRO4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 10:56:30 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:59627 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933496Ab0FRO43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 10:56:29 -0400
Date: Fri, 18 Jun 2010 09:56:22 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: linux-kernel@vger.kernel.org
cc: Julia Lawall <julia@diku.dk>, Manfred Spraul <manfred@colorfullife.com>
Subject: Re: 2.6.35-rc3 deadlocks on semaphore operations
In-Reply-To: <alpine.DEB.2.00.1006180940140.11575@router.home>
Message-ID: <alpine.DEB.2.00.1006180955141.11575@router.home>
References: <alpine.DEB.2.00.1006180940140.11575@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One important fact that I forgot to mention: This is on a dual quad core
dell box (8 hardware threads) with CONCURRENCY_LEVEL set to 9.


