Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab1DOETn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 00:19:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47612 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab1DOETm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 00:19:42 -0400
Date: Fri, 15 Apr 2011 00:19:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: gregkh@suse.de, linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        balbi@ti.com, Maya Erez <merez@codeaurora.org>,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH v6 1/5] usb: Add streams support to the gadget
 framework
Message-ID: <20110415041939.GB27928@infradead.org>
References: <1302788149-27926-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302788149-27926-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I already told you before please do not create new SCSI target code
that doesn't use the target core in drivers/target.  Thanks!

