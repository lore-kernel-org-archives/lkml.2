Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1B1OXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:23:49 -0500
Received: from kroah.org ([198.145.64.141]:43098 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304Ab1B1OXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:23:48 -0500
Date: Mon, 28 Feb 2011 06:15:27 -0800
From: Greg KH <greg@kroah.com>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: Re: RFC: [PATCH 0/5] staging: sep: Enable kernel crypto
Message-ID: <20110228141527.GA25667@kroah.com>
References: <1298869824-4246-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298869824-4246-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 09:10:24PM -0800, Mark Allyn wrote:
> This is a set of 5 patches to enable kernel crypto operation of the
> SEP device
> 
> All patches are required as a set.
> 
> Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>

Is this really a "request for comments" set of patches, or do you want
me to apply them to my tree?

confused,

greg k-h
