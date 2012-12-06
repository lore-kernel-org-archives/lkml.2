Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424710Ab2LFT3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:29:05 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:33543 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423225Ab2LFT3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:29:03 -0500
Date: Thu, 6 Dec 2012 11:20:39 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com
Subject: Re: [PATCH 5/6] cfq-iosched: Get rid of unnecessary local variable
Message-ID: <20121206192039.GD3676@htj.dyndns.org>
References: <1349297821-30078-1-git-send-email-vgoyal@redhat.com>
 <1349297821-30078-6-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349297821-30078-6-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 04:57:00PM -0400, Vivek Goyal wrote:
> Use of local varibale "n" seems to be unnecessary. Remove it. This brings
> it inline with function __cfq_group_st_add(), which is also doing the
> similar operation of adding a group to a rb tree.
> 
> No functionality change here.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Acked-by: Jeff Moyer <jmoyer@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
