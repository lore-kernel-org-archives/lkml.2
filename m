Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab1KKEqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 23:46:08 -0500
Received: from gate.crashing.org ([63.228.1.57]:60046 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab1KKEqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 23:46:07 -0500
Message-ID: <1320986742.21206.52.camel@pasglop>
Subject: Re: [RFC PATCH 08/17] powerpc/e500: Remove conditional "lwsync"
 substitution
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>,
        Scott Wood <scottwood@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Baruch Siach <baruch@tkos.co.il>, Timur Tabi <B04825@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Mackerras <paulus@samba.org>
Date: Fri, 11 Nov 2011 15:45:42 +1100
In-Reply-To: <FCE81732-AD2B-4EF2-BC31-E24D0F9D41A9@kernel.crashing.org>
References: <4E42AB6F.1050900@freescale.com>
	 <1320883635-17194-9-git-send-email-Kyle.D.Moffett@boeing.com>
	 <3937191C-A735-4668-8E80-9FB4B35E2F63@kernel.crashing.org>
	 <20111110163100.GA11983@schlenkerla.am.freescale.net>
	 <AC287A9B-0C8B-494E-95CD-A33014AECE22@kernel.crashing.org>
	 <20111110170334.GF11983@schlenkerla.am.freescale.net>
	 <4567A1A9-51D2-4D21-9080-BD3D78901C1D@boeing.com>
	 <FCE81732-AD2B-4EF2-BC31-E24D0F9D41A9@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-10 at 14:34 -0600, Kumar Gala wrote:

> No idea, we have to ask Ben how much he cares.  I don't see any FSL
> customers pushing us to run the same kernel on A2 and P5020 (or future
> FSL devices).

I do care. For example, imagine somebody wanting to support an
enterprise distro on both BG/Q and some FSL based HW ...

Besides, this has generally forced us to do things more cleanly and I
don't want to go back into #ifdef land. These cores are both arch 2.06 E
compilant, there is no good reason to prevent or forbid having them
build into a single binary image.

Look at the mess ARM got into and the pain they are having getting out
of with that stuff ... No way I'm going backward with split configs. If
anything, I'd like to reconcile things even more.

Cheers,
Ben.


