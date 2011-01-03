Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab1ACTou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 14:44:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752229Ab1ACTot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 14:44:49 -0500
Date: Mon, 3 Jan 2011 11:43:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sedat Dilek <sedat.dilek@googlemail.com>
Cc: dilinger@queued.net, sameo@linux.intel.com, tj@kernel.org, joe@perches.com,
        linux-kernel@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH] misc/cs5535: Fix section mismatch derived from
 cs5535_mfgpt_drv variable
Message-Id: <20110103114310.8b06e73e.akpm@linux-foundation.org>
In-Reply-To: <1294023088-31687-1-git-send-email-sedat.dilek@gmail.com>
References: <1294023088-31687-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Jan 2011 03:51:28 +0100
Sedat Dilek <sedat.dilek@googlemail.com> wrote:

> >From my build.log:
> 
> WARNING: drivers/misc/cs5535-mfgpt.o(.data+0x0): Section mismatch in reference from the variable cs5535_mfgpt_drv to the function .devinit.text:cs5535_mfgpt_probe()
> The variable cs5535_mfgpt_drv references
> the function __devinit cs5535_mfgpt_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Confused.  cs5535_mfgpt_probe() _does_ have a name of the form
"*_probe", so why did it warn?


