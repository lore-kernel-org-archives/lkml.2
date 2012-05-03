Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab2ECKAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 06:00:49 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:37775 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab2ECKAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 06:00:48 -0400
Date: Thu, 3 May 2012 12:00:40 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch V2 22/31] s390: Use generic init_task
Message-ID: <20120503100040.GA4162@osiris.boeblingen.de.ibm.com>
References: <20120503083859.991965503@linutronix.de>
 <20120503085035.271439530@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503085035.271439530@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12050310-0342-0000-0000-000001973211
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 09:02:58AM -0000, Thomas Gleixner wrote:
> Same code. Use the generic version. The special Makefile treatment is
> pointless anyway as init_task.o contains only data which is handled by
> the linker script. So no point on being treated like head text.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>

