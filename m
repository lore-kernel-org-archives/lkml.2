Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab1AUIrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 03:47:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55632 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab1AUIrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 03:47:35 -0500
Date: Fri, 21 Jan 2011 03:47:29 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: gregkh@suse.de, linux-arm-msm@vger.kernel.org,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH 1/4] uasp: MS UAS Protocol implementation -
 Infrastructure
Message-ID: <20110121084729.GA12517@infradead.org>
References: <1295595854-23232-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295595854-23232-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 09:44:13AM +0200, Tatyana Brokhman wrote:
> This patch implements the infrastructure for the UASP function driver.
> The UASP Function driver registers as a second configuration of the MS
> Function driver.

We now have a proper scsi target infrastructure in drivers/target,
please use it.

