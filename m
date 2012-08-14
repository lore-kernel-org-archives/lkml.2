Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab2HNCa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 22:30:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45778 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab2HNC36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 22:29:58 -0400
Date: Tue, 14 Aug 2012 03:29:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: John Fastabend <john.r.fastabend@intel.com>
Cc: nhorman@tuxdriver.com, netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [net PATCH v1 1/2] net: netprio: fix files lock and remove
 useless d_path bits
Message-ID: <20120814022951.GF23464@ZenIV.linux.org.uk>
References: <20120814013939.3144.13167.stgit@jf-dev1-dcblab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814013939.3144.13167.stgit@jf-dev1-dcblab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 06:39:39PM -0700, John Fastabend wrote:
> -			path = d_path(&file->f_path, tmp, PAGE_SIZE);

What's using tmp after that patch and do you still need to bother
allocating it?
