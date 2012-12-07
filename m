Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab2LGAGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:06:43 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:37236 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab2LGAGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:06:41 -0500
Date: Thu, 6 Dec 2012 19:06:33 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: zwu.kernel@gmail.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: remove some unused code lines
Message-ID: <20121207000633.GA8896@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, zwu.kernel@gmail.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
References: <1354183200-8628-1-git-send-email-zwu.kernel@gmail.com>
 <20121202122726.GA14852@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121202122726.GA14852@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 02, 2012 at 08:27:26PM +0800, Zheng Liu wrote:
> On Thu, Nov 29, 2012 at 06:00:00PM +0800, zwu.kernel@gmail.com wrote:
> > From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> Please write a commit log to describe this patch, even though it is
> quite simple and straightfoward
> 
> Otherwise, it looks good to me.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

I've applied this patch with the description:

    ext4: remove unused variable from ext4_ext_in_cache()

					- Ted
