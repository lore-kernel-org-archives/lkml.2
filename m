Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390Ab1ESN4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:56:53 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:52862
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933289Ab1ESN4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:56:50 -0400
X-SpamScore: 2
X-BigFish: VS2(z3c23mz98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DD52195.7060104@freescale.com>
Date: Thu, 19 May 2011 08:56:37 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/2.0.14-1.fc13 SeaMonkey/2.0.14
MIME-Version: 1.0
To: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <greg@kroah.com>,
        <akpm@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>
Subject: Re: [PATCH 0/7] This patchset adds support for running Linux under
 the Freescale hypervisor,
References: <1305813272-31826-1-git-send-email-timur@freescale.com>
In-Reply-To: <1305813272-31826-1-git-send-email-timur@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi wrote:
> have hypervisor extensions (e.g. the P4080 which has an e500mc core).

Oops, this email got munged.  The first paragraph should say:

This patchset adds support for running Linux under the Freescale hypervisor,
which is an ePAPR-compliant hypervisor that runs on our PowerPC SOCs that
have hypervisor extensions (e.g. the P4080 which has an e500mc core).

-- 
Timur Tabi
Linux kernel developer at Freescale

