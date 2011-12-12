Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab1LLHm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:42:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65002 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab1LLHm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:42:26 -0500
Date: Sun, 11 Dec 2011 23:42:19 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Xi Wang <xi.wang@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: signedness bug in cma3000_thread_irq()
Message-ID: <20111212074219.GA4682@core.coreip.homeip.net>
References: <1323672566-16738-1-git-send-email-xi.wang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323672566-16738-1-git-send-email-xi.wang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 01:49:26AM -0500, Xi Wang wrote:
> The error check (intr_status < 0) didn't work because intr_status is
> a u8.  Change its type to signed int.
> 

Applied, thank you.

-- 
Dmitry
