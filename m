Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab1DTO0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 10:26:36 -0400
Received: from kroah.org ([198.145.64.141]:60478 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab1DTO0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 10:26:13 -0400
Date: Wed, 20 Apr 2011 07:27:02 -0700
From: Greg KH <greg@kroah.com>
To: Richard Weinberger <richard@nod.at>
Cc: akpm@linux-foundation.org, Martin Walch <walch.martin@web.de>,
        linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, stable@kernel.org
Subject: Re: [stable] [PATCH 2/3] um: Add support for 64 bit atomic operations
Message-ID: <20110420142702.GB22114@kroah.com>
References: <1303299266-10219-1-git-send-email-richard@nod.at>
 <1303299266-10219-2-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303299266-10219-2-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 01:34:25PM +0200, Richard Weinberger wrote:
> This adds support for 64 bit atomic operations on
> 32 bit UML systems.
> XFS needs them since 2.6.38.
> 
> Reported-by: Martin Walch <walch.martin@web.de>
> Tested-by: Martin Walch <walch.martin@web.de>
> Cc: Martin Walch <walch.martin@web.de>
> Cc: <stable@kernel.org> # .38.x 084189a: um: disable CONFIG_CMPXCHG_LOCAL

Why is this a stable patch?

confused,

greg k-h
