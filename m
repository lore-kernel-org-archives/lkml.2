Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab1COPEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 11:04:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab1COPEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 11:04:37 -0400
Date: Tue, 15 Mar 2011 11:04:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Lina Lu <lulina_nuaa@foxmail.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Re: Re: blk-throttle.c : When limit is changed, must
 startanewslice
Message-ID: <20110315150405.GB24984@redhat.com>
References: <tencent_6A5F95FF2112DFE963C44E4E@qq.com>
 <201103110038174067110@foxmail.com>
 <201103121933025463003@foxmail.com>
 <201103142352342813806@foxmail.com>
 <201103152300242189340@foxmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103152300242189340@foxmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 11:00:25PM +0800, Lina Lu wrote:

[..]
> Hi Vivek,
> I have test the following patch on 2.6.39 core branch of Jens's tree, the bug has
> been fixed. 

Thanks Lina. I will cleanup this patch and post for inclusion.

> 
> Can you tell me which patch makes the throtl_tg_on_rr() return 1 even if the limits
> are very high?

Following patches fixes the issue in Jens's tree.

commit de701c74a34005e637e1ca2634fbf28fd1debba2
Author: Vivek Goyal <vgoyal@redhat.com>
Date:   Mon Mar 7 21:09:32 2011 +0100

    blk-throttle: Some cleanups and race fixes in limit  update code

Thanks
Vivek
