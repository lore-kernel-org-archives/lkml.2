Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab0ISXwA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 19:52:00 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:46219 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab0ISXv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 19:51:59 -0400
Date: Mon, 20 Sep 2010 00:51:32 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Bernhard Walle <walle@corscience.de>
Cc: linux-mips@linux-mips.org, ddaney@caviumnetworks.com,
        akpm@linux-foundation.org, ebiederm@xmission.com, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: N32: Fix getdents64 syscall for n32
Message-ID: <20100919235131.GA29977@linux-mips.org>
References: <1283501734-6532-1-git-send-email-walle@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283501734-6532-1-git-send-email-walle@corscience.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 10:15:34AM +0200, Bernhard Walle wrote:

> Commit 31c984a5acabea5d8c7224dc226453022be46f33 introduced a new syscall
> getdents64. However, in the syscall table, the new syscall still refers
> to the old getdents which doesn't work.
> 
> The problem appeared with a system that uses the eglibc 2.12-r11187
> (that utilizes that new syscall) is very confused. The fix has been
> tested with that eglibc version.

Thanks Bernhard!

  Ralf
