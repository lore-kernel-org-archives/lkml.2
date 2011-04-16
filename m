Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272Ab1DPXHp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 19:07:45 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:53769 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab1DPXHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 19:07:36 -0400
Date: Sat, 16 Apr 2011 19:07:31 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Yang Ruirui <ruirui.r.yang@tieto.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: release page cache in ext4_mb_load_buddy error
 path
Message-ID: <20110416230731.GA3806@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Yang Ruirui <ruirui.r.yang@tieto.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20110414064441.GA3499@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414064441.GA3499@darkstar>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 02:44:41PM +0800, Yang Ruirui wrote:
> Add missing page_cache_release in the error path of ext4_mb_load_buddy
> 
> Signed-off-by: Yang Ruirui <ruirui.r.yang@tieto.com>

Thanks, added to the ext4 tree.

					- Ted
