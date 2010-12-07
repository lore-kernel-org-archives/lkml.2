Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab0LGVdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 16:33:24 -0500
Received: from kroah.org ([198.145.64.141]:52707 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab0LGVdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 16:33:20 -0500
Date: Tue, 7 Dec 2010 13:05:12 -0800
From: Greg KH <greg@kroah.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Borislav Petkov <bp@amd64.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86-32: Separate 1:1 pagetables from swapper_pg_dir
Message-ID: <20101207210512.GA14849@kroah.com>
References: <20101111141358.GA4641@kroah.com>
 <1289488576-18117-2-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289488576-18117-2-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 04:16:14PM +0100, Joerg Roedel wrote:
> commit fd89a137924e0710078c3ae855e7cec1c43cb845 upstream

applied, thanks.

greg k-h
