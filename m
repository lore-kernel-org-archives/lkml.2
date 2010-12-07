Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab0LGVdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 16:33:23 -0500
Received: from kroah.org ([198.145.64.141]:52714 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab0LGVdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 16:33:20 -0500
Date: Tue, 7 Dec 2010 13:06:15 -0800
From: Greg KH <greg@kroah.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@amd64.org>,
        stable@kernel.org
Subject: Re: [stable] [PATCH 2/3] x86, mm: Fix CONFIG_VMSPLIT_1G and 2G_OPT
 trampoline
Message-ID: <20101207210615.GB14849@kroah.com>
References: <20101111141358.GA4641@kroah.com>
 <1289488576-18117-3-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289488576-18117-3-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 04:16:15PM +0100, Joerg Roedel wrote:
> From: Hugh Dickins <hughd@google.com>
> 
> commit b7d460897739e02f186425b7276e3fdb1595cea7 upstream

Applied, thanks.

greg k-h
