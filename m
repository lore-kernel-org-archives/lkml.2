Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab0JFO0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 10:26:23 -0400
Received: from relais.videotron.ca ([24.201.245.36]:64290 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758948Ab0JFO0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 10:26:22 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 06 Oct 2010 10:26:21 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] [ARM] Translate delay.S into (mostly) C
In-reply-to: <4CABEECB.4030301@codeaurora.org>
Message-id: <alpine.LFD.2.00.1010061024220.3107@xanadu.home>
References: <1285644827-6846-1-git-send-email-sboyd@codeaurora.org>
 <1285644827-6846-2-git-send-email-sboyd@codeaurora.org>
 <1286299355.18791.11.camel@c-dwalke-linux.qualcomm.com>
 <4CABEECB.4030301@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Oct 2010, Stephen Boyd wrote:

>  On 10/05/2010 10:22 AM, Daniel Walker wrote:
> > I think the "size" command might be better for this type of stuff. It
> > should give you the same output (or similar).. It's just used more
> > frequently. 
> 
> Ok.
> 
> $ size vmlinux.orig
>    text    data     bss     dec     hex filename
> 6533503  530232 1228296 8292031  7e86bf vmlinux.orig
> $ size vmlinux.new
>    text    data     bss     dec     hex filename
> 6533607  530232 1228296 8292135  7e8727 vmlinux.new

If you modified only one source file then I'd suggest you run 'size' 
only on the affected .o file instead.


Nicolas
