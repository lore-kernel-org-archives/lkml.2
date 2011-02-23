Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab1BWWL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 17:11:27 -0500
Received: from ozlabs.org ([203.10.76.45]:49468 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab1BWWL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 17:11:26 -0500
Date: Thu, 24 Feb 2011 09:11:21 +1100
From: Anton Blanchard <anton@samba.org>
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Matthew McClintock <msm@freescale.com>,
        "Livingston, John A" <john.a.livingston@boeing.com>
Subject: Re: mpc85xx: kexec build broken by "powerpc/kexec: Remove
 ppc_md.machine_kexec"
Message-ID: <20110224091121.43b31dad@kryten>
In-Reply-To: <B87A2622-0006-4FC8-893A-41DBBF0CA170@boeing.com>
References: <B87A2622-0006-4FC8-893A-41DBBF0CA170@boeing.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Kyle,

> As far as I can tell, "machine_kexec" was removed in commit c9486878
> (powerpc/kexec: Remove ppc_md.machine_kexec) on Jan 6th, 2011, which
> claims that it was not used.
> 
> Unfortunately it looks like it *is* used by the mpc85xx kexec()
> support (commit f933a41e), added on Jul 21, 2010.

Thanks for the report. Testing a patch now.

Anton
