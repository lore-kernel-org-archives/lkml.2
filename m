Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab2CLQWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:22:42 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60500 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2CLQWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:22:39 -0400
Date: Mon, 12 Mar 2012 09:22:34 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: use percpu allocator for cwq on UP
Message-ID: <20120312162234.GB23255@google.com>
References: <4F59D568.4030604@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F59D568.4030604@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 06:03:20PM +0800, Lai Jiangshan wrote:
> I notice that the commit bbddff makes percpu allocator can work on UP,
> So we don't need the magic way for UP.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied to wq/for-3.4.  Thanks.

-- 
tejun
