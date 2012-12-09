Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934296Ab2LIRv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 12:51:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766Ab2LIRvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 12:51:24 -0500
Date: Sun, 9 Dec 2012 18:51:22 +0100
From: Michal Marek <mmarek@suse.cz>
To: Joonsoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] scripts/tags.sh: Support subarch for ARM
Message-ID: <20121209175122.GC29331@pobox.suse.cz>
References: <1354557873-21889-1-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354557873-21889-1-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 03:04:32AM +0900, Joonsoo Kim wrote:
> +elif [ "${SRCARCH}" = "arm" -a "${SUBARCH}" != "" ]; then
> +	subarchdir=$(find ${tree}arch/$SRCARCH/ -name mach-* -type d -o \
> +							-name plat-* -type d);

Please quote the patterns, otherwise the shell will expand them if you
have a file named mach-* or plat-* in the top-level directory.
