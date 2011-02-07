Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1BGQFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 11:05:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab1BGQFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 11:05:40 -0500
Date: Mon, 7 Feb 2011 11:04:51 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Haefliger, Juerg" <Juerg.Haefliger@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Block IO throttling disabled in distros
Message-ID: <20110207160451.GH7437@redhat.com>
References: <59DD1BA8FD3C0F4C90771C18F2B5B53A653FF7284B@GVW0432EXB.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59DD1BA8FD3C0F4C90771C18F2B5B53A653FF7284B@GVW0432EXB.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 03:33:38PM +0000, Haefliger, Juerg wrote:
> Hi,
> 
> Both RHEL6 and Ubuntu 10.10 have block IO throttling disabled in their kernels. Does anybody know why that is? Are there performance or stability issues with the throttling controller or does it somehow negatively interfere with the rest of the kernel and/or system?

Block IO throttling support was not even upstream at that time hence
you don't see it. 

I have not heard about any stability issues so far. Of course more testing
will reveal that.

The only thing I have thinking is that should we limit the number of bios
queued per IO context on the device. Currently there is no such limit
and one can queue up as many bios as one want to.

Thanks
Vivek
