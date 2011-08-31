Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab1HaJbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 05:31:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64332 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab1HaJbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 05:31:31 -0400
Date: Wed, 31 Aug 2011 13:31:26 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pekka Enberg <penberg@kernel.org>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 0/2] minor cleanups to EFLAGS initialisation in
 ret_from_fork
Message-ID: <20110831093125.GE1911@sun>
References: <1314782541.28989.37.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314782541.28989.37.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 10:22:21AM +0100, Ian Campbell wrote:
> This fell off my radar but Cyrill kindly reminded me so here is a repost
> of my short cleanup to remove the kernel_eflags variable from 64 bit and
> to converge the ret_from_fork paths on 32 and 64 bit slightly.
> 

Thanks Ian, I'll try to review them today.

	Cyrill
