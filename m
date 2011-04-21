Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab1DULzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 07:55:38 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:33622 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1DULzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 07:55:37 -0400
Date: Thu, 21 Apr 2011 13:55:16 +0200
From: Borislav Petkov <bp@amd64.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: "rwhitton@iee.org" <rwhitton@iee.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] edac: Remove debugging output in scrub rate handling
Message-ID: <20110421115516.GE10263@aftab>
References: <16117.1303310442@jupiter.eclipse.co.uk>
 <4DAEF98D.2090802@ladisch.de>
 <20110420153529.GA2312@gere.osrc.amd.com>
 <20110420154658.GD1624@x4.trippels.de>
 <20110420155853.GB2312@gere.osrc.amd.com>
 <20110420164506.GE1624@x4.trippels.de>
 <20110420165533.GA1624@x4.trippels.de>
 <20110420173627.GE2734@aftab>
 <20110420182845.GA1614@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110420182845.GA1614@x4.trippels.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 02:28:45PM -0400, Markus Trippelsdorf wrote:
>
> This patch removes superfluous debugging output in the sysfs scrub rate
> handler. It also consolidates the error handling in
> mci_sdram_scrub_rate_store.
> 
> Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>

Applied, thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
