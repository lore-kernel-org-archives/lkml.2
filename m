Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab0IAJP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:15:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60069 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab0IAJPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:15:50 -0400
Date: Wed, 1 Sep 2010 10:14:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexander Shishkin <virtuoso@slind.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] wire up sys_time_change_notify() on ARM
Message-ID: <20100901091455.GL8142@n2100.arm.linux.org.uk>
References: <1283255151-6364-1-git-send-email-virtuoso@slind.org> <1283255151-6364-2-git-send-email-virtuoso@slind.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283255151-6364-2-git-send-email-virtuoso@slind.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 02:45:46PM +0300, Alexander Shishkin wrote:
> sys_time_change_notify() is a new syscall with number and types of
> parameters such that no ARM-specific processing is needed.

This patch needs to be redone.  Please wait until I've finished catching
up with the last 10 or so days of email and merged my tree into mainline.
Alternatively, update your patch to apply on top of my master branch.
