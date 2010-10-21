Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248Ab0JUPQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:16:26 -0400
Received: from fieldses.org ([174.143.236.118]:36823 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab0JUPQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:16:25 -0400
Date: Thu, 21 Oct 2010 11:16:21 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Tom Tucker <tom@opengridcomputing.com>
Cc: Tejun Heo <tj@kernel.org>, Trond Myklebust <Trond.Myklebust@netapp.com>,
        linux-nfs@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Tom Tucker <tom@ogc.us>
Subject: Re: [PATCH linux-2.6.36-rc7] sunrpc/xprtrdma: clean up workqueue
 usage
Message-ID: <20101021151621.GA8738@fieldses.org>
References: <4CB87807.7050108@kernel.org>
 <20101015171132.GA18869@fieldses.org>
 <4CB89393.6000207@opengridcomputing.com>
 <4CB8A745.5020206@kernel.org>
 <4CBF1331.70107@opengridcomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBF1331.70107@opengridcomputing.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 11:05:05AM -0500, Tom Tucker wrote:
>  On 10/15/10 2:11 PM, Tejun Heo wrote:
> >On 10/15/2010 07:46 PM, Tom Tucker wrote:
> >>  On 10/15/10 12:11 PM, J. Bruce Fields wrote:
> >>>Tom, could you take a look?
> >>>
> >>This looks reasonable to me.
> >>
> >>My bet is that it wasn't tested though due to hardware
> >>availability. I'll test it this weekend and let you know how it
> >>goes.
> >Yeap, only compile tested.  Testing would be much appreciated.
> >
> Tejun,
> 
> I've tested this now with iozone etc... works like a charm ;-)

Applied, thanks!

--b.
