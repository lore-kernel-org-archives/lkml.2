Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab2KUUMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 15:12:18 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:32896 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182Ab2KUUMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 15:12:17 -0500
Date: Wed, 21 Nov 2012 13:12:10 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter H?we <PeterHuewe@gmx.de>
Cc: Peter.Huewe@infineon.com, key@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH v4] TPM: Issue TPM_STARTUP at driver load if the TPM has
 not been started
Message-ID: <20121121201210.GE12822@obsidianresearch.com>
References: <74A44E99E3274B4CB570415926B37D440EAA91@MUCSE501.eu.infineon.com>
 <20121121183713.GA12822@obsidianresearch.com>
 <201211212117.55040.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211212117.55040.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 09:17:54PM +0100, Peter H?we wrote:

> Care to change to 
> > +			"A TPM error (%zd) occurred attempting to determine the timeouts\n",
> 
> Sorry that I didn't spot it earlier.

Right.. Probably like this in my tree because of:

http://permalink.gmane.org/gmane.linux.kernel/1397887

I should really get sparse setup here... Never enough hours.

Jason
