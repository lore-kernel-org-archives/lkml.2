Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab3ABSUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 13:20:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963Ab3ABSUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 13:20:47 -0500
Date: Wed, 2 Jan 2013 13:20:38 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, axboe@kernel.dk, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [PATCHSET] block: implement blkcg hierarchy support in cfq,
 take#2
Message-ID: <20130102182037.GC4306@redhat.com>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356726946-26037-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 12:35:22PM -0800, Tejun Heo wrote:

[..]
> 
> * Updated to reflect Vivek's reviews - renames & documentation.

Hi Tejun,

You forgot to update blkio-controller.txt.

Thanks
Vivek
