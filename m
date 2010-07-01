Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab0GANx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:53:58 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54682 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab0GANx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:53:56 -0400
Date: Thu, 1 Jul 2010 14:53:48 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
       =?iso-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] dell-wmi: fix a memory leak
Message-ID: <20100701135348.GF31804@srcf.ucam.org>
References: <1277889946.30827.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277889946.30827.2.camel@mola>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 05:25:46PM +0800, Axel Lin wrote:
> If dell_new_hk_type is true, dell_legacy_wmi_keymap will point to a memory
> allocated in setup_new_hk_map().
> In this case, the memory is not freed in current implementation.
> This patch fixes the leak by kfree(dell_wmi_keymap) if dell_new_hk_type is true.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
