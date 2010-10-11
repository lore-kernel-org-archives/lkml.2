Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab0JKELI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 00:11:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34482 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab0JKELF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 00:11:05 -0400
Date: Sun, 10 Oct 2010 22:11:02 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Andres Salomon <dilinger@queued.net>
Cc: devicetree-discuss@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] of: add package-to-path support to pdt
Message-ID: <20101011041102.GE23588@angua.secretlab.ca>
References: <20101010020609.3adde588@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101010020609.3adde588@debxo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 02:06:09AM -0700, Andres Salomon wrote:
> 
> package-to-path is a PROM function which tells us the real (full) name of the
> node.  This provides a hook for that in the prom ops struct, and makes use
> of it in the pdt code when attempting to determine a node's name.  If the
> hook is available, try using it (falling back to looking at the "name"
> property if it fails).
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Applied, thanks.

g.

