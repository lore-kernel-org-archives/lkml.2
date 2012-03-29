Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231Ab2C2MNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 08:13:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34281 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab2C2MNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 08:13:24 -0400
Date: Thu, 29 Mar 2012 13:13:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] linux: ARM: memmap: Revise freeing unused memmap
	entries for SPARSEMEM
Message-ID: <20120329121313.GF22414@n2100.arm.linux.org.uk>
References: <20120329190113.3891.38390934@jp.panasonic.com> <20120329190252.3895.38390934@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120329190252.3895.38390934@jp.panasonic.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 07:02:52PM +0900, Akira Takeuchi wrote:
> F0-F4 is the unused memory regions and their corresponding memmap entries
> can be freed. However, free_unused_memmap() only frees the entries for
> F1/F2/F4, and does not free the entries for F0/F3.

No we're not going to support having free areas at the start of an
otherwise populated bank of memory.  This is just insane.  Fix your
hardware instead or your sparsemem setup.
