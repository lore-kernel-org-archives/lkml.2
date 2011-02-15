Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab1BOK6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 05:58:01 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44040 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab1BOK57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 05:57:59 -0500
Date: Tue, 15 Feb 2011 05:57:55 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, james_p_freyensee@linux.intel.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
Subject: Re: [PATCH 01/12] export kernel call get_task_comm()
Message-ID: <20110215105755.GC21311@infradead.org>
References: <james_p_freyensee@linux.intel.com>
 <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
 <20110208193857.GA8839@infradead.org>
 <45773.10.23.16.85.1297194256.squirrel@linux.intel.com>
 <20110208202852.160c080b@lxorguk.ukuu.org.uk>
 <20110208202856.GA16696@infradead.org>
 <20110208203602.636575b3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110208203602.636575b3@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 08:36:02PM +0000, Alan Cox wrote:
> Which is a detail you really don't want to leak out of the proper
> abstraction use. I really don't see why you are advocating bad
> programming practice - everything else uses the abstraction properly,
> this just happens to be the first modular case that wants to behave
> properly.

Just grep for current->comm uses and get_task_comm uses and see that
this is not true.

