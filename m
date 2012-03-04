Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab2CDJMe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 04:12:34 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53150
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896Ab2CDJMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 04:12:32 -0500
Date: Sun, 4 Mar 2012 04:12:25 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command to
 the host
Message-ID: <20120304091225.GA27297@infradead.org>
References: <1330721347-26781-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330721347-26781-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 12:49:07PM -0800, K. Y. Srinivasan wrote:
> Windows hosts don't handle the ATA_16 command; don't pass it to the host.

Most devices don't handle it, and answer with and unsupported opcode
sense reason.  If hyperv iis buggy enough to crap out on it please add
a comment explaining that.
