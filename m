Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053Ab2LVGDw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 01:03:52 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47605 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2LVGDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 01:03:50 -0500
Date: Sat, 22 Dec 2012 06:03:46 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Simon Marchi <simon.marchi@polymtl.ca>
Cc: cmetcalf@tilera.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] arch/tile: Implement user_stack_pointer
Message-ID: <20121222060345.GU4939@ZenIV.linux.org.uk>
References: <1356153672-17545-1-git-send-email-simon.marchi@polymtl.ca>
 <1356153672-17545-2-git-send-email-simon.marchi@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356153672-17545-2-git-send-email-simon.marchi@polymtl.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2012 at 12:21:11AM -0500, Simon Marchi wrote:
> It is needed when we turn on HAVE_ARCH_TRACEHOOK.

... and if you check the mainline, you'll see it (and other missing
user_stack_pointer() instances) already in place, as part of infrastructure
for sigaltstack series.
