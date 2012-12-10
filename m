Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab2LJKfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:35:54 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52406 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736Ab2LJKfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:35:53 -0500
Date: Mon, 10 Dec 2012 16:05:46 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: bigeasy@linutronix.de, oleg@redhat.com, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, benh@kernel.crashing.org, mingo@elte.hu,
        anton@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] uprobes/powerpc: Make use of generic routines
	to enable single step
Message-ID: <20121210103545.GC31751@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20121203150438.7727.74924.stgit@suzukikp> <20121203150946.7727.82735.stgit@suzukikp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203150946.7727.82735.stgit@suzukikp>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121010-7182-0000-0000-000003A83926
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 08:40:32PM +0530, Suzuki K. Poulose wrote:
> From: Suzuki K. Poulose <suzuki@in.ibm.com>
> 
> Replace the ptrace helpers with the powerpc generic routines to
> enable/disable single step. We save/restore the MSR (and DCBR for BookE)
> across for the operation. We don't have to disable the single step,
> as restoring the MSR/DBCR would restore the previous state.
> 
> Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

