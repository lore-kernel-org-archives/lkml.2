Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab0LBNk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 08:40:26 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48703 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551Ab0LBNkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 08:40:25 -0500
Date: Thu, 2 Dec 2010 07:52:57 -0600
From: David Sin <davidsin@ti.com>
To: "Varadarajan, Charulatha" <charu@ti.com>
Cc: Greg KH <greg@kroah.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC v2 0/8] TI DMM-TILER driver
Message-ID: <20101202135254.GE22875@lba0869738>
References: <1291147139-23472-1-git-send-email-davidsin@ti.com>
 <AANLkTi=39XEC9ie=bAapymAtx6k+ej49N5B1+_gfRhmE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=39XEC9ie=bAapymAtx6k+ej49N5B1+_gfRhmE@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 12:17:22PM +0530, Varadarajan, Charulatha wrote:
> On Wed, Dec 1, 2010 at 01:28, David Sin <davidsin@ti.com> wrote:
> 
> The dmm driver is making use of omap_hwmod fw. But I could not see a patch
> to add  dmm hwmod data to omap4 hwmod base in this series. Is this patch series
> tested?
yes -- this code has been tested against the omap_hwmod fw.  I will send 
out a patch in the next rev.  Thanks for your comments.
-- 
David Sin
