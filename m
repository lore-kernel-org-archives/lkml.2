Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab1JBPhH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 11:37:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47529 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab1JBPhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 11:37:00 -0400
Date: Sun, 2 Oct 2011 16:36:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] Generic ARM fixes for randconfig
Message-ID: <20111002153646.GX11710@n2100.arm.linux.org.uk>
References: <1317496920-7764-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317496920-7764-1-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 09:21:49PM +0200, Arnd Bergmann wrote:
> Please pull these into your tree, or alternatively cherry-pick the
> ones that you are happy with if you disagree with some of them.

I think I'll merge all but the first from this - I think the first
should be part of a cross-arch cleanup.
