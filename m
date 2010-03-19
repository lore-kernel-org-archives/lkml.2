Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab0CSVto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 17:49:44 -0400
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:38892 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752810Ab0CSVtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 17:49:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=XqDQWBIDp7xiRvrDaBoc3RDgL+BvP4Lq6MriUv8JiIMqUaUXysqCiqBm0Ff07Q8QFb6JYF/00/Efrq4+qSyXRgtoBEhjvk2ELhjzB6lOqdUMkLMHteRJNyiyyJAezzQM;
Date: Fri, 19 Mar 2010 14:49:46 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] pci: Convert pci_lock to raw_spinlock
Message-ID: <20100319144946.0dbc2c82@jbarnes-piketon>
In-Reply-To: <20100217143453.570657459@linutronix.de>
References: <20100217143401.673569070@linutronix.de>
	<20100217143453.570657459@linutronix.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010 14:35:19 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> pci_lock must be a real spinlock in preempt-rt. Convert it to
> raw_spinlock. No change for !RT kernels.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Applied these to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
