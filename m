Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab0H0Cv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 22:51:57 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42956 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab0H0Cvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 22:51:54 -0400
Date: Fri, 27 Aug 2010 03:51:48 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: linux-next: build warning after merge of the drivers-x86 tree
Message-ID: <20100827025148.GA25469@srcf.ucam.org>
References: <20100827115950.dd942b90.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100827115950.dd942b90.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 11:59:50AM +1000, Stephen Rothwell wrote:

> After merging the drivers-x86 tree, today's linux-next build (powerpc
> ppc64_defconfig and x86_64 allmodconfig) produced this warning:

Oh Lordy. I should stop merging anything that contains "select". I'll 
take a look at this tomorrow, but I'm about to head away for a week - if 
anyone has a fix, feel free to find a way to get it merged.

(Dmitry, there was a Kconfig issue when I merged your patch, so it's 
entirely plausible that you're a completely innocent bystander here)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
