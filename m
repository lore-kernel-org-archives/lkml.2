Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762502Ab2DLKbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 06:31:07 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:33977
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753183Ab2DLKbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 06:31:05 -0400
X-SpamScore: -19
X-BigFish: VPS-19(zz1432N98dKzz1202hzz15d4Rz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2D3VJ-01-05A-02
X-M-MSG: 
Date: Thu, 12 Apr 2012 12:30:00 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Jakub Kicinski <kubakici@wp.pl>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dma-debug: release free_entries_lock before saving stack
 trace
Message-ID: <20120412103000.GM2428@amd.com>
References: <1333502350-19420-1-git-send-email-kubakici@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1333502350-19420-1-git-send-email-kubakici@wp.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 03:19:10AM +0200, Jakub Kicinski wrote:
> Saving stack trace can take a while and once the entry
> is allocated free_entries_lock is no longer needed.
> 
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>

Applied, thanks.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

