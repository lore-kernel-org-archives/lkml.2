Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990Ab2GBKPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:15:32 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:37388
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932909Ab2GBKPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:15:30 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1202hzz8275bhz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M6J35J-02-3B0-02
X-M-MSG: 
Date: Mon, 2 Jul 2012 12:15:20 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Neil Horman <nhorman@tuxdriver.com>, Jakub Kicinski <kubakici@wp.pl>,
        Alan Stern <stern@rowland.harvard.edu>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: Re: [patch 1/2 -resend] dma-debug: debugfs_create_bool() takes a u32
 pointer
Message-ID: <20120702101520.GC2558@amd.com>
References: <20120627085800.GA3007@mwanda>
 <20120627090854.GS31212@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120627090854.GS31212@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 12:08:55PM +0300, Dan Carpenter wrote:
> Even though it has "bool" in the name, you have pass a u32 pointer to
> debugfs_create_bool().  Otherwise you get memory corruption in
> write_file_bool().  Fortunately in this case the corruption happens in
> an alignment hole between variables so it doesn't cause any problems.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied both, thanks Dan.


