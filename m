Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab1EKVPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:15:54 -0400
Received: from kroah.org ([198.145.64.141]:59131 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756176Ab1EKVOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:14:47 -0400
Date: Wed, 11 May 2011 14:08:37 -0700
From: Greg KH <greg@kroah.com>
To: matt mooney <mfmooney@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 06/12] staging: usbip: stub_main.c: code cleanup
Message-ID: <20110511210837.GA4893@kroah.com>
References: <cover.1305103212.git.mfm@muteddisk.com>
 <3a932c55376e57a96881a654a0f6c3e6837f400e.1305103212.git.mfm@muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a932c55376e57a96881a654a0f6c3e6837f400e.1305103212.git.mfm@muteddisk.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 01:54:18AM -0700, matt mooney wrote:
> Reorder functions; remove match_find() and replace with
> get_busid_idx(); change other functions to use get_busid_idx(); and
> code cleanup in the other functions.
> 
> Signed-off-by: matt mooney <mfm@muteddisk.com>
> ---
> I apologize for this one. I realize that I should have split it into two with
> the reorder being separate.

Yes, please split it up.

> Also, it seems as if there is a synchronization problem carried over from the
> original code in get_busid_priv(). An address into the busid_table is returned
> and then the element is accessed and modified elsewhere. Right? Or am I missing
> something.

You might be correct, I don't really know.

thanks,

greg k-h
