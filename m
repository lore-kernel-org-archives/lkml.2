Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab2LJKeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:34:14 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51976 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab2LJKeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:34:12 -0500
Date: Mon, 10 Dec 2012 16:04:03 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: bigeasy@linutronix.de, oleg@redhat.com, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, benh@kernel.crashing.org,
        Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, anton@redhat.com, mingo@elte.hu
Subject: Re: [PATCH v2 2/4] powerpc: Move the single step enable code to a
	generic path
Message-ID: <20121210103403.GA31751@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20121203150438.7727.74924.stgit@suzukikp> <20121203150754.7727.42629.stgit@suzukikp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203150754.7727.42629.stgit@suzukikp>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121010-7182-0000-0000-000003A8386A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 08:38:37PM +0530, Suzuki K. Poulose wrote:
> From: Suzuki K. Poulose <suzuki@in.ibm.com>
> 
> This patch moves the single step enable code used by kprobe to a generic
> routine header so that, it can be re-used by other code, in this case,
> uprobes. No functional changes.
> 
> Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
> Cc:	Ananth N Mavinakaynahalli <ananth@in.ibm.com>
> Cc:	Kumar Gala <galak@kernel.crashing.org>
> Cc:	linuxppc-dev@ozlabs.org

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

