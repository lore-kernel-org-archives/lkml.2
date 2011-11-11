Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab1KKEnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 23:43:46 -0500
Received: from gate.crashing.org ([63.228.1.57]:60017 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab1KKEnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 23:43:45 -0500
Message-ID: <1320986595.21206.49.camel@pasglop>
Subject: Re: [RFC PATCH 08/17] powerpc/e500: Remove conditional "lwsync"
 substitution
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Cc: Scott Wood <scottwood@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Baruch Siach <baruch@tkos.co.il>, Timur Tabi <B04825@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Mackerras <paulus@samba.org>
Date: Fri, 11 Nov 2011 15:43:15 +1100
In-Reply-To: <4567A1A9-51D2-4D21-9080-BD3D78901C1D@boeing.com>
References: <4E42AB6F.1050900@freescale.com>
	 <1320883635-17194-9-git-send-email-Kyle.D.Moffett@boeing.com>
	 <3937191C-A735-4668-8E80-9FB4B35E2F63@kernel.crashing.org>
	 <20111110163100.GA11983@schlenkerla.am.freescale.net>
	 <AC287A9B-0C8B-494E-95CD-A33014AECE22@kernel.crashing.org>
	 <20111110170334.GF11983@schlenkerla.am.freescale.net>
	 <4567A1A9-51D2-4D21-9080-BD3D78901C1D@boeing.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-10 at 14:27 -0600, Moffett, Kyle D wrote:
> 
> Does this mean that PPC_BOOK3E_64 needs to be split into two separate
> Book 3-III families the same way that 32-bit has been split?  Is there
> another way around it? 

No, I don't want more split, on the contrary.

Cheers,
Ben.


