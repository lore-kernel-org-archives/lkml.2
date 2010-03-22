Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab0CVToM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:44:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727Ab0CVToK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:44:10 -0400
Date: Mon, 22 Mar 2010 12:43:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-mmc@vger.kernel.org, Chaithrika U S <chaithrika@ti.com>,
       Vipin Bhandari <vipin.bhandari@ti.com>,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] davinci: MMC: updates to suspend/resume
 implementation
Message-Id: <20100322124333.40d728bb.akpm@linux-foundation.org>
In-Reply-To: <1268771425-6277-2-git-send-email-khilman@deeprootsystems.com>
References: <1268771425-6277-1-git-send-email-khilman@deeprootsystems.com>
	<1268771425-6277-2-git-send-email-khilman@deeprootsystems.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Mar 2010 13:30:25 -0700
Kevin Hilman <khilman@deeprootsystems.com> wrote:

> +static struct dev_pm_ops davinci_mmcsd_pm = {
> +	.suspend        = davinci_mmcsd_suspend,
> +	.resume         = davinci_mmcsd_resume,
> +};

checkpatch said

WARNING: struct dev_pm_ops should normally be const
#83: FILE: drivers/mmc/host/davinci_mmc.c:1379:
+static struct dev_pm_ops davinci_mmcsd_pm = {

I'll make that change.  Please check.
