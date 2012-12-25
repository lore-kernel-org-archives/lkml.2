Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab2LYLLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 06:11:16 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36197 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641Ab2LYLLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 06:11:13 -0500
Date: Tue, 25 Dec 2012 12:11:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: wei_wang@realsil.com.cn
Cc: cjb@laptop.org, sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, oakad@yahoo.com
Subject: Re: [PATCH v2 2/8] MFD:rtsx: Remove redundant code
Message-ID: <20121225111111.GD7692@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, wei_wang@realsil.com.cn,
	cjb@laptop.org, sameo@linux.intel.com, devel@linuxdriverproject.org,
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
	gregkh@linuxfoundation.org, arnd@arndb.de, oakad@yahoo.com
References: <cover.1356403281.git.wei_wang@realsil.com.cn>
 <29a6ff4a0fa5f8f307ed98de97b2ef9643352782.1356403281.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <29a6ff4a0fa5f8f307ed98de97b2ef9643352782.1356403281.git.wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 25, 2012 at 10:43:03AM +0800, wei_wang@realsil.com.cn wrote:
> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> In function rtsx_pci_add_sg_tbl, the statement "ptr++" is useless.
> 
> Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>

Acked-by: Borislav Petkov <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
