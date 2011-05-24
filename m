Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab1EXN7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:59:32 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:60684 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755266Ab1EXN7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:59:31 -0400
Date: Tue, 24 May 2011 14:59:40 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Pengfei Zhang <zoppof.zhang@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS:i8259.c remove resume and shutdown to syscore_ops
Message-ID: <20110524135940.GA30117@linux-mips.org>
References: <1306239558-4997-1-git-send-email-zoppof.zhang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306239558-4997-1-git-send-email-zoppof.zhang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 08:19:18PM +0800, Pengfei Zhang wrote:

> Remove the resume and shutdown of i8259A from the sysdev_class
> to the syscore_ops since these members had removed from the
> structure sysdev_class.

I don't see why one would want to want to first call register_syscore_ops
then sysdev_class_register and sysdev_register?

  Ralf
