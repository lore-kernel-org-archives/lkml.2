Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab0GANxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:53:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54657 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509Ab0GANxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:53:32 -0400
Date: Thu, 1 Jul 2010 14:53:23 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Len Brown <len.brown@intel.com>, Thomas Renninger <trenn@suse.de>,
       platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] acer-wmi: set permissions on interface file to S_IRUGO
Message-ID: <20100701135323.GD31804@srcf.ucam.org>
References: <1277864423.14363.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277864423.14363.1.camel@mola>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 10:20:23AM +0800, Axel Lin wrote:
> The interface file is not writable, thus set permissions to S_IRUGO.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
