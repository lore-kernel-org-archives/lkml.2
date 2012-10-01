Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab2JAQJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 12:09:14 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:33553 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab2JAQJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 12:09:13 -0400
Date: Mon, 1 Oct 2012 10:09:12 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter.Huewe@infineon.com
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH] TPM: Let the tpm char device be openable
 multiple times
Message-ID: <20121001160912.GB31620@obsidianresearch.com>
References: <20120930233345.GJ30637@obsidianresearch.com>
 <74A44E99E3274B4CB570415926B37D440EAA7F@MUCSE501.eu.infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74A44E99E3274B4CB570415926B37D440EAA7F@MUCSE501.eu.infineon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 09:07:11AM +0000, Peter.Huewe@infineon.com wrote:
> Hi Jason,
> 
> one quick question:
> -	TPM_BUFSIZE = 4096,
> [...]
> +	u8 data_bufferx[2048];
> 
> Why do you half the buffer size?

I missed 7f366784f5c2b8fc065 when I rebased the patch, thanks!

Jason
