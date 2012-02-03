Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab2BCVJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 16:09:28 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40483 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605Ab2BCVJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 16:09:27 -0500
Date: Fri, 3 Feb 2012 13:09:22 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 11/11] blkcg: unify blkg's for blkcg policies
Message-ID: <20120203210922.GC14209@google.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-12-git-send-email-tj@kernel.org>
 <20120202003730.GC19837@google.com>
 <20120203210656.GB12616@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203210656.GB12616@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 03, 2012 at 04:06:56PM -0500, Vivek Goyal wrote:
> Shouldn't we shoot down root group policy data upon elevator switch?
> Otherwise once the elevator comes back, it will continue to use old
> policy data (old stats, overwrite old weigts etc.).

It's racy and hacky but we do shoot down policy specific data and
reinit them.  The behavior should be fine although implementation is
seriously ugly for now.

Thanks.

-- 
tejun
