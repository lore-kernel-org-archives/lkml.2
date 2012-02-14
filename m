Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab2BNWz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 17:55:28 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55190 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757381Ab2BNWz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 17:55:27 -0500
X-Sasl-enc: rLUfIyxNNopeUD0CARXUTMqBkZ9UjWfx8vBVaMGMnGk8 1329260126
Date: Tue, 14 Feb 2012 14:49:51 -0800
From: Greg KH <greg@kroah.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [take 2] pohmelfs: call for inclusion
Message-ID: <20120214224951.GD21350@kroah.com>
References: <20120214220613.GA16117@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214220613.GA16117@ioremap.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 01:06:13AM +0300, Evgeniy Polyakov wrote:
> Hi
> 
> I'm please to announce new and completely rewritten distributed
> filesystem - POHMELFS

<snip>

You also might want to cc: linux-fsdevel on new filesystems, as that's
where the developers who can review this properly live.

thanks,

greg k-h
