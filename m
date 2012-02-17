Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab2BQUlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 15:41:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab2BQUlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 15:41:14 -0500
Date: Fri, 17 Feb 2012 15:41:08 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] block: ioc_task_link() can't fail
Message-ID: <20120217204108.GF26620@redhat.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-6-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329431878-28300-6-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 02:37:54PM -0800, Tejun Heo wrote:
> ioc_task_link() is used to share %current's ioc on clone.  If
> %current->is_context is set, %current is guaranteed to have refcount

Typo. s/is_context/io_context.

Thanks
Vivek
