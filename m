Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab1EXNbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:31:12 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:35270 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756349Ab1EXNbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:31:10 -0400
Date: Tue, 24 May 2011 14:31:17 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Yoichi Yuasa <yuasa@linux-mips.org>
Cc: linux-mips <linux-mips@linux-mips.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Pengfei Zhang <zoppof.zhang@gmail.com>
Subject: Re: [PATCH] MIPS: Use struct syscore_ops instead of sysdevs for i8259
Message-ID: <20110524133117.GA3292@linux-mips.org>
References: <20110520224141.5eb118ff.yuasa@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520224141.5eb118ff.yuasa@linux-mips.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 10:41:41PM +0900, Yoichi Yuasa wrote:

Thanks, applied.

  Ralf
