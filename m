Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab1DFOYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:24:33 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:8962 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab1DFOYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:24:32 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4R8275bhz32i637h668h839h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJ8ION-02-AP7-02
X-M-MSG: 
Date: Wed, 6 Apr 2011 16:24:22 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Greg KH <gregkh@suse.de>
CC: Hank Janssen <hjanssen@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: hv_mouse: Fix build error
Message-ID: <20110406142422.GR23633@amd.com>
References: <1302084896-25250-1-git-send-email-joerg.roedel@amd.com>
 <20110406140326.GA20688@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110406140326.GA20688@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 10:03:26AM -0400, Greg KH wrote:
> On Wed, Apr 06, 2011 at 12:14:56PM +0200, Joerg Roedel wrote:
> > The compiler argues about the implictly declared udelay
> > function. Fix it by adding the appropriate include.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> 
> Already queued up to go to Linus in the linux-next tree.

Ok, fine. I just noticed it when building -rc2 with another .config.

Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

