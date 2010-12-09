Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab0LIDhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 22:37:23 -0500
Received: from mail.vyatta.com ([76.74.103.46]:39648 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab0LIDhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 22:37:22 -0500
Date: Wed, 8 Dec 2010 19:37:20 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] e1000e: cleanup
Message-ID: <20101208193720.5e137627@nehalam>
In-Reply-To: <1291862457-16671-1-git-send-email-asbjorn@asbjorn.biz>
References: <1291862457-16671-1-git-send-email-asbjorn@asbjorn.biz>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 Dec 2010 02:40:50 +0000
Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz> wrote:

> Hi,
> 
> This patchset fixes most checkstyle problems in e1000e.
> 
> Checkpatch summary:
> pre:	total:	221 errors,	129 warnings,	24520 lines checked
> post:	total:	2 errors,	34 warnings,	24533 lines checked

IMHO these patches are in the why bother category, they deal only
with whitespace and things that checkpatch is too stupid to understand.

Checkpatch is a rough saw only appropriate to doing initial cutting
through crap drivers.
