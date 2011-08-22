Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab1HVMpC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 08:45:02 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:5752
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752040Ab1HVMo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 08:44:56 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz98dKzz1202hzz15d4Rz32i668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LQBY2P-01-2Y4-02
X-M-MSG: 
Date: Mon, 22 Aug 2011 14:44:27 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Neil Horman <nhorman@tuxdriver.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Divy LeRay <divy@chelsio.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] dma-debug: hash_bucket_find needs to allow for offsets
 within an entry (v2)
Message-ID: <20110822124427.GE2079@amd.com>
References: <1311097278-30841-1-git-send-email-nhorman@tuxdriver.com>
 <20110808191354.GA22117@hmsreliant.think-freely.org>
 <20110810133158.GB7598@amd.com>
 <20110822104621.GA12337@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110822104621.GA12337@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On Mon, Aug 22, 2011 at 06:46:21AM -0400, Neil Horman wrote:

> Hey, Jeorg, just wondering if you managed to get a look at this?
> Neil

It is not forgotten :) This is my first day back in office and I will
look into it today.

Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

