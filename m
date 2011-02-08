Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705Ab1BHUEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 15:04:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46984 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab1BHUEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 15:04:46 -0500
Date: Tue, 8 Feb 2011 15:04:44 -0500
From: Christoph Hellwig <hch@infradead.org>
To: james_p_freyensee@linux.intel.com
Cc: Christoph Hellwig <hch@infradead.org>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
Subject: Re: [PATCH 01/12] export kernel call get_task_comm()
Message-ID: <20110208200444.GA23329@infradead.org>
References: <james_p_freyensee@linux.intel.com>
 <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
 <20110208193857.GA8839@infradead.org>
 <45773.10.23.16.85.1297194256.squirrel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45773.10.23.16.85.1297194256.squirrel@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 11:44:16AM -0800, james_p_freyensee@linux.intel.com wrote:
> That is originally what I did, but after talking with Greg KH, Arjan vdv,
> and Alan Cox I made this patch instead.

Care to explain why exactly?

