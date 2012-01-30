Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab2A3WU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:20:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab2A3WU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:20:26 -0500
Date: Mon, 30 Jan 2012 14:18:38 -0800
From: Greg KH <gregkh@suse.de>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [RFC PATCH] telephony: Move to staging
Message-ID: <20120130221838.GA5904@suse.de>
References: <cd8d3ef8b646dc0b1c451e61c57d639cadbc7c21.1327961290.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd8d3ef8b646dc0b1c451e61c57d639cadbc7c21.1327961290.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 02:11:34PM -0800, Joe Perches wrote:
> This stuff is really old and in quite poor shape.
> Does anyone still use it?
> 
> If not, I think it's appropriate to let it simmer
> in staging for a few releases.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Is this really unmaintained?

Fine with me, but you need a message/TODO file that says if someone
needs/wants it, to ask you, and it will be moved back.

Care to add that to the patch and resend it?

thanks,

greg k-h
