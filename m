Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab1EHQkK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 12:40:10 -0400
Received: from kroah.org ([198.145.64.141]:38471 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102Ab1EHQkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 12:40:08 -0400
Date: Sun, 8 May 2011 09:40:54 -0700
From: Greg KH <greg@kroah.com>
To: Borislav Petkov <bp@amd64.org>
Cc: EDAC devel <linux-edac@vger.kernel.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 3/4] EDAC, MCE, AMD: Add hw_inject and cpu sysfs attrs
Message-ID: <20110508164054.GA4199@kroah.com>
References: <1304614176-7063-1-git-send-email-bp@amd64.org>
 <1304614176-7063-4-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304614176-7063-4-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 06:49:35PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Add sysfs handlers for the 'hw_inject' and 'cpu' attrs.

You forgot to add the proper Documentation/ABI/ files for these new
sysfs files.  Please do that.

thanks,

greg k-h
