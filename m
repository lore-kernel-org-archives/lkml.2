Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab1DGPN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 11:13:26 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.181]:31548
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751279Ab1DGPNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 11:13:25 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4R8275bhz32i637h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJAFM4-02-3JY-02
X-M-MSG: 
Date: Thu, 7 Apr 2011 17:13:16 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] dma-debug: print information about leaked entry
Message-ID: <20110407151316.GZ23633@amd.com>
References: <20110331120759.GA5230@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110331120759.GA5230@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 08:08:09AM -0400, Stanislaw Gruszka wrote:
> When driver leak dma mapping, print additional information about one of
> leaked entries, to to help investigate problem. Patch should be useful
> for debugging drivers, which maps many different class of buffers.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Applied, thanks.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

