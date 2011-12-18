Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab1LRVpi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 16:45:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab1LRVpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 16:45:36 -0500
Date: Sun, 18 Dec 2011 22:45:34 +0100
From: Michal Marek <mmarek@suse.cz>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ctags: remove struct forward declarations
Message-ID: <20111218214533.GE25931@sepie.suse.cz>
References: <20111126190200.GA13297@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111126190200.GA13297@p183.telecom.by>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 10:02:00PM +0300, Alexey Dobriyan wrote:
> They're quite pointless and obscure location of real structure definition.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Thanks, applied to kbuild.git#misc.

Michal
