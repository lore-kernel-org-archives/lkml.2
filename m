Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab1KIJ7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 04:59:30 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:9739 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab1KIJ71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 04:59:27 -0500
X-SpamScore: -18
X-BigFish: VPS-18(zz1503M98dKzz1202hzz15d4Rz2dh668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LUE130-02-13N-02
X-M-MSG: 
Date: Wed, 9 Nov 2011 10:59:02 +0100
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>
Subject: Re: [PATCH] pci: More PRI/PASID cleanup
Message-ID: <20111109095902.GB13213@amd.com>
References: <20111103034359.10286.19062.stgit@bling.home>
 <20111108162826.GD5182@amd.com>
 <1320770670.19116.23.camel@bling.home>
 <20111108171725.GE5182@amd.com>
 <1320773518.19116.30.camel@bling.home>
 <20111108175410.GH5182@amd.com>
 <1320776406.19116.42.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1320776406.19116.42.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 11:20:06AM -0700, Alex Williamson wrote:

> My guess is that someone asked why a device would ever expose this table
> if it didn't support enable as a capability.  So, I wouldn't be
> surprised if your hardware sets it, but it's probably just as safe to
> assume enable is supported if the PASID table exists.

That is probably true. I suggest that you split the functional change
out of the patch and do only the renaming. I look over the code again
then and change it in a way that works with reality and the spec. Does
that work for you?


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

