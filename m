Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab1BHU3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 15:29:01 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33649 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750Ab1BHU3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 15:29:00 -0500
Date: Tue, 8 Feb 2011 15:28:56 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: james_p_freyensee@linux.intel.com, Christoph Hellwig <hch@infradead.org>,
        gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
Subject: Re: [PATCH 01/12] export kernel call get_task_comm()
Message-ID: <20110208202856.GA16696@infradead.org>
References: <james_p_freyensee@linux.intel.com>
 <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
 <20110208193857.GA8839@infradead.org>
 <45773.10.23.16.85.1297194256.squirrel@linux.intel.com>
 <20110208202852.160c080b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110208202852.160c080b@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 08:28:52PM +0000, Alan Cox wrote:
> On Tue, 8 Feb 2011 11:44:16 -0800 (PST)
> > > From current you can just dereference current->comm, and access from
> > > other threads from drivers is a bad idea.
> 
> You need to take the locks for it - which get_task_comm encapsulates.

Not for current->comm, which is the only thing it cares about.
