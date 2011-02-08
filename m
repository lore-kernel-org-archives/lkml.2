Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab1BHTjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 14:39:01 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60552 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab1BHTjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 14:39:00 -0500
Date: Tue, 8 Feb 2011 14:38:57 -0500
From: Christoph Hellwig <hch@infradead.org>
To: james_p_freyensee@linux.intel.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
Subject: Re: [PATCH 01/12] export kernel call get_task_comm()
Message-ID: <20110208193857.GA8839@infradead.org>
References: <james_p_freyensee@linux.intel.com>
 <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
 <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 11:34:46AM -0800, james_p_freyensee@linux.intel.com wrote:
> From: J Freyensee <james_p_freyensee@linux.intel.com>
> 
> This allows drivers who call this function to be compiled modularly.
> Otherwise, a driver who is interested in this type of functionality
> has to implement their own.

NAK.

>From current you can just dereference current->comm, and access from
other threads from drivers is a bad idea.

