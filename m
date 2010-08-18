Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab0HRORU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 10:17:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38017 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab0HRORT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 10:17:19 -0400
Date: Wed, 18 Aug 2010 15:17:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jkmalinen@gmail.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] uml: fix hostfs lookup
Message-ID: <20100818141712.GN31363@ZenIV.linux.org.uk>
References: <E1OlimD-0006YS-3T@pomaz-ex.szeredi.hu>
 <E1Olirt-0006aI-DV@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Olirt-0006aI-DV@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 03:39:49PM +0200, Miklos Szeredi wrote:
> Oops, sorry.  Off-by-one bug crept in there.

It's already fixed in the queue (see #untested in vfs-2.6)
