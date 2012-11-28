Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab2K1XmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 18:42:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab2K1XmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 18:42:07 -0500
Date: Wed, 28 Nov 2012 15:42:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] aoe: miscellaneous fixes follow-up recent patch
 submissions
Message-Id: <20121128154206.813a54f6.akpm@linux-foundation.org>
In-Reply-To: <cover.1353518444.git.ecashin@coraid.com>
References: <cover.1353518444.git.ecashin@coraid.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2012 19:52:41 -0500
Ed Cashin <ecashin@coraid.com> wrote:

> This patch series applies to today's linux-next/akpm, commit
> d3faae60d84f586ff8937b77c8476bca1b5f8ec6.
> 
> Ed L. Cashin (8):
>   aoe: copy fallback timing information on destination failover
>   aoe: remove vestigial request queue allocation
>   aoe: increase default cap on outstanding AoE commands in the network
>   aoe: cleanup: correct comment for aoetgt nout
>   aoe: remove call to request handler from I/O completion
>   aoe: make error messages more specific in static minor allocation
>   aoe: initialize sysminor to avoid compiler warning
>   aoe: return real minor number for static minors

This series didn't contain your usual
aoe-update-driver-internal-version-number-to-xx.patch
