Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab1CEE7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 23:59:06 -0500
Received: from relais.videotron.ca ([24.201.245.36]:37714 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab1CEE7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 23:59:03 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 04 Mar 2011 23:59:03 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Michael Spang <mspang@csclub.uwaterloo.ca>
Cc: Lennert Buytenhek <kernel@wantstofly.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: Add TS-7800 revisions 6-9
In-reply-to: <1299299957-13018-1-git-send-email-mspang@csclub.uwaterloo.ca>
Message-id: <alpine.LFD.2.00.1103042357310.27995@xanadu.home>
References: <1299299957-13018-1-git-send-email-mspang@csclub.uwaterloo.ca>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Mar 2011, Michael Spang wrote:

> The RTC, NAND, and RNG devices are not enabled on current TS-7800s.
> The manufacturer is at revision 9 (at least), and they do support
> these devices. We'll assume revisions 6 through 8 do as well.
> 
> Signed-off-by: Michael Spang <mspang@csclub.uwaterloo.ca>

Alexander Clouter <alex@digriz.org.uk> did send the exact same patch on 
February 16 already.


Nicolas
