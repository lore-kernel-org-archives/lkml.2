Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab0GANxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:53:46 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54662 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054Ab0GANxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:53:44 -0400
Date: Thu, 1 Jul 2010 14:53:34 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Len Brown <len.brown@intel.com>, Thomas Renninger <trenn@suse.de>,
       platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] acer-wmi: make dmi_matched to return 1 instead of 0
Message-ID: <20100701135334.GE31804@srcf.ucam.org>
References: <1277875936.22265.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277875936.22265.2.camel@mola>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 01:32:16PM +0800, Axel Lin wrote:
> dmi_check_system() walks the table running matching functions until someone
> returns non zero or we hit the end.
> 
> This patch makes dmi_matched to return 1 so dmi_check_system() return
> immediately when a match is found.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
