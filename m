Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab0FSIk4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 04:40:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50765 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab0FSIkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 04:40:55 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com
Subject: Re: [PATCH] Add TAINT_HARDWARE_UNSUPPORTED flag
References: <20100617134654.22523.39845.sendpatchset@prarit.bos.redhat.com>
Date: Sat, 19 Jun 2010 10:40:53 +0200
In-Reply-To: <20100617134654.22523.39845.sendpatchset@prarit.bos.redhat.com>
	(Prarit Bhargava's message of "Thu, 17 Jun 2010 09:54:45 -0400")
Message-ID: <87ocf7o1nu.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prarit Bhargava <prarit@redhat.com> writes:
nt\n");
> +	if (flag == TAINT_HARDWARE_UNSUPPORTED)
> +		printk(KERN_CRIT "WARNING: This system's hardware is "
> +		       "unsupported.\n");

The problem with such a message in mainline is that it would
imply that other hardware is actually 'supported'

Which is not really true in most cases.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
