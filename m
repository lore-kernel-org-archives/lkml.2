Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab2JSOyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:54:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837Ab2JSOx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:53:58 -0400
Date: Fri, 19 Oct 2012 10:53:50 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix use-after-free of q->root_blkg and q->root_rl.blkg
Message-ID: <20121019145350.GD27052@redhat.com>
References: <50750367.2070508@ce.jp.nec.com>
 <20121010155929.GA18733@redhat.com>
 <50762182.5090806@ce.jp.nec.com>
 <20121016232040.GH16166@google.com>
 <507DF58E.8060804@ce.jp.nec.com>
 <20121017134704.GB31663@redhat.com>
 <507F6FE2.3030303@ce.jp.nec.com>
 <20121018133149.GA18147@redhat.com>
 <20121018212053.GK13370@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018212053.GK13370@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 02:20:53PM -0700, Tejun Heo wrote:
> Hey, Vivek.
> 
> On Thu, Oct 18, 2012 at 09:31:49AM -0400, Vivek Goyal wrote:
> > Tejun, for the sake of readability, are you fine with keeping the original
> > check and original patch which I had acked.
> 
> Can you please send another patch to change that?  It really isn't a
> related change and I don't wanna mix the two.

Sure. Jun'ichi, would you like to send that cleanup line in a separate patch? 

Thanks
Vivek
