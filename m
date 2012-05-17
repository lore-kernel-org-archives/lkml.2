Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762246Ab2EQRnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 13:43:32 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35818 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758969Ab2EQRna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 13:43:30 -0400
Date: Thu, 17 May 2012 21:43:26 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [rfc 3/4] fs, eventfd: Add procfs fdinfo helper
Message-ID: <20120517174326.GA28556@moon>
References: <20120517160738.116113099@openvz.org>
 <20120517162534.755208902@openvz.org>
 <4FB528B3.8000406@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB528B3.8000406@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 08:34:59PM +0400, Pavel Emelyanov wrote:
> <snip>
> 
> > +static const struct seq_operations eventfd_fdinfo_ops = {
> > +	.start	= seq_start,
> > +	.next	= seq_next,
> > +	.stop	= seq_stop,
> > +	.show	= seq_show,
> 
> I think, you can use the single_ part of the seq files engine.

single_stop only, since for other cases this seq methods should
provide data iif pos is 1.

	Cyrill
