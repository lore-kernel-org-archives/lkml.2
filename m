Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab0JAQkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 12:40:25 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56537 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab0JAQkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 12:40:23 -0400
Date: Fri, 1 Oct 2010 17:39:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Fernando Guzman Lugo <x0095840@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, Hiroshi.DOYU@nokia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scatterlist: define SG chain for arm architecture
Message-ID: <20101001163958.GA22533@n2100.arm.linux.org.uk>
References: <1285950521-8093-1-git-send-email-x0095840@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285950521-8093-1-git-send-email-x0095840@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 11:28:41AM -0500, Fernando Guzman Lugo wrote:
> Define SG chain for ARM architecture in order to work
> with big buffers. This patch is needed in order to
> iovmm users can pass a big buffer to map it and ARM
> architecture has not issues using SG chain.
> 
> This change was suggested by FUJITA Tomonori.

Have you audited all places where SG lists are used in the ARM
architecture to ensure that SG chain support is safe?  (That
goes for ARM generic code and ARM specific drivers.)

If the answer is no, this patch is unacceptable until such a
review has been carried out.
