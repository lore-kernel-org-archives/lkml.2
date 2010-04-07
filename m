Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214Ab0DGR2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:28:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758100Ab0DGR2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:28:44 -0400
Date: Wed, 7 Apr 2010 13:28:33 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Chad Talbott <ctalbott@google.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, Nauman Rafique <nauman@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH 1/2 V3] io-controller: Add a new interface
	"weight_device" for IO-Controller
Message-ID: <20100407172833.GB3206@redhat.com>
References: <20100303154748.GC2866@redhat.com> <e98e18941003031519v14d4f79cg33da5c3cf1f5ac03@mail.gmail.com> <1786ab031003031825m5467c86jf5c355df10001dd2@mail.gmail.com> <4B8F27BD.2020704@cn.fujitsu.com> <4B8F62B7.3080401@cn.fujitsu.com> <20100304152400.GB18786@redhat.com> <4B906BB6.3080104@cn.fujitsu.com> <20100305141300.GA3296@redhat.com> <4BAB027D.7000405@cn.fujitsu.com> <i2o1786ab031004071012t51ae0a10t3b4f30bece40d8a6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <i2o1786ab031004071012t51ae0a10t3b4f30bece40d8a6@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 10:12:03AM -0700, Chad Talbott wrote:
> On Wed, Mar 24, 2010 at 11:28 PM, Gui Jianfeng
> <guijianfeng@cn.fujitsu.com> wrote:
> > Vivek Goyal wrote:
> >> On Fri, Mar 05, 2010 at 10:25:58AM +0800, Gui Jianfeng wrote:
> >>> V2->V3 changes:
> >>> - Move policy_*_node() functions up to get rid of forward declarations
> >>> - rename related functions by adding prefix "blkio_"
> >>>
> >>
> >> Thanks for the changes Gui. Looks good to me.
> >>
> >> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> >
> > Hi Jens,
> >
> > This patchset seems to get lost. Just for reminding. Any comments?
> 
> Hi Jens,
> 
> Just want to add a quick note that we're excited about this
> functionality and are hoping to see it go in.
> 

I guess this patchset is now going to conflict with Divyesh's changes.

Gui, once blkio stat patches (cleaned up ones) are committed may be you
can rebase your changes on top of that. It will become easier for Jens.
(Until and unless he has some objections to this patchset).

Thanks
Vivek
