Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965325Ab1KJQtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:49:32 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:18485
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932644Ab1KJQtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:49:31 -0500
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Date: Thu, 10 Nov 2011 10:49:20 -0600
From: Scott Wood <scottwood@freescale.com>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Baruch Siach <baruch@tkos.co.il>, Timur Tabi <B04825@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Paul Bolle <pebolle@tiscali.nl>,
        Sonny Rao <sonnyrao@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 13/17] powerpc/e500: Add a new CONFIG_FSL_E5500
 option for the e5500
Message-ID: <20111110164920.GD11983@schlenkerla.am.freescale.net>
References: <4E42AB6F.1050900@freescale.com>
 <1320883635-17194-14-git-send-email-Kyle.D.Moffett@boeing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1320883635-17194-14-git-send-email-Kyle.D.Moffett@boeing.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 07:07:11PM -0500, Kyle Moffett wrote:
> As part of splitting CONFIG_E500 into separate options for e500v1/v2 and
> e500mc/e5500, some code only needs to be built when e5500 support is
> required.

How much code is this?  e5500 is basically just a 64-bit version of
e500mc.  When running a 32-bit kernel the extra code should be minimal.

-Scott

