Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab0EAKLn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 06:11:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:32996 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab0EAKLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 06:11:41 -0400
Date: Sat, 1 May 2010 11:11:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Michael Roth <mroth@nessie.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [ARM] .gitignore: Ignore piggy.lzo, lib1funcs.S and
	vmlinux
Message-ID: <20100501101123.GF12172@n2100.arm.linux.org.uk>
References: <1272015498-10749-1-git-send-email-mroth@nessie.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272015498-10749-1-git-send-email-mroth@nessie.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 11:38:18AM +0200, Michael Roth wrote:
> Commit e7db7b4270ed2a606b8c0b5f944a5f92ade0e84c added LZO compressed
> kernels, lib1funcs.S is copied from the appropriate ARM sub-arch
> and vmlinux is the obvious fruit of all efforts.

Looks fine, please submit to the patch system if not already done so.
Thanks.
