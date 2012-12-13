Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab2LMPXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:23:46 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:39137 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753031Ab2LMPXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:23:12 -0500
Message-ID: <1355412191.12036.2.camel@joe-AO722>
Subject: Re: [PATCHv3 4/7] gpu: host1x: Add debug support
From: Joe Perches <joe@perches.com>
To: Terje Bergstrom <tbergstrom@nvidia.com>
Cc: thierry.reding@avionic-design.de, dev@lynxeye.de,
        linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
        amerilainen@nvidia.com, linux-kernel@vger.kernel.org
Date: Thu, 13 Dec 2012 07:23:11 -0800
In-Reply-To: <1355407484-28904-5-git-send-email-tbergstrom@nvidia.com>
References: <1355407484-28904-1-git-send-email-tbergstrom@nvidia.com>
	 <1355407484-28904-5-git-send-email-tbergstrom@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-13 at 16:04 +0200, Terje Bergstrom wrote:
> Add support for host1x debugging. Adds debugfs entries, and dumps
> channel state to UART in case of stuck job.

trivial note:

[]

> diff --git a/drivers/gpu/host1x/debug.h b/drivers/gpu/host1x/debug.h
[]
> +void host1x_debug_output(struct output *o, const char *fmt, ...);

This should be marked __printf(2, 3)
so the compiler verifies format and argument types.


