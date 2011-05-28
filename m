Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1E1Lgt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 07:36:49 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:36129 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813Ab1E1Lgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 07:36:48 -0400
X-Sasl-enc: 6MuykUDIbc2o4GnfvM+FzvFkQluXassSCh5iOaarAiSP 1306582607
Date: Sat, 28 May 2011 18:17:57 +0800
From: Greg KH <greg@kroah.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>, a.p.zijlstra@chello.nl,
        mingo@elte.hu, acme@redhat.com, ming.m.lin@intel.com,
        "Brown, Len" <lenb@kernel.org>
Subject: Re: [PATCH 2/3] introduce intel_rapl driver
Message-ID: <20110528101757.GA32493@kroah.com>
References: <1306398857.2207.157.camel@rui>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306398857.2207.157.camel@rui>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 04:34:17PM +0800, Zhang Rui wrote:
> +/*
> + *  Intel RAPL interface driver
> + *
> + *  Copyright (C) 2010-2011 Zhang Rui <rui.zhang@intel.com>
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or (at
> + *  your option) any later version.

Are you really sure about "any later version"?  I didn't think that was
the default rule of Intel kernel code these days, have you verified this
exception is ok?

> + *
> + *  This program is distributed in the hope that it will be useful, but
> + *  WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + *  General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License along
> + *  with this program; if not, write to the Free Software Foundation, Inc.,
> + *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.

These two paragraphs are not needed, and the last one is never needed
unless you want to track the office movements of the FSF for the next
50+ years and always update this file because of that.

greg k-h
