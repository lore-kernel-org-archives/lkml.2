Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab2LJKf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:35:27 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:45935 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab2LJKf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:35:26 -0500
Date: Mon, 10 Dec 2012 16:05:13 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: bigeasy@linutronix.de, oleg@redhat.com, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, benh@kernel.crashing.org, mingo@elte.hu,
        anton@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] uprobes/powerpc: Introduce routines for
	save/restore context
Message-ID: <20121210103513.GB31751@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20121203150438.7727.74924.stgit@suzukikp> <20121203150849.7727.53296.stgit@suzukikp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203150849.7727.53296.stgit@suzukikp>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121010-3620-0000-0000-00000096990E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 08:39:35PM +0530, Suzuki K. Poulose wrote:
> From: Suzuki K. Poulose <suzuki@in.ibm.com>
> 
> Introduce routines for saving and restoring the context
> befre/after the single step. No functional changes involved.
> 
> These will be extended later to save/restore more info about
> the process once we replace the ptrace helpers.
> 
> Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

