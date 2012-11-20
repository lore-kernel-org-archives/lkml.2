Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab2KTCVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 21:21:46 -0500
Received: from void.printf.net ([89.145.121.20]:59612 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029Ab2KTCVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 21:21:44 -0500
From: Chris Ball <cjb@laptop.org>
To: <wei_wang@realsil.com.cn>
Cc: <sameo@linux.intel.com>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <arnd@arndb.de>, <oakad@yahoo.com>,
        <bp@alien8.de>
Subject: Re: [PATCH v2 1/2] mmc/host/rtsx: Configure SD_CFG2 register in sd_rw_multi
References: <cover.1353377266.git.wei_wang@realsil.com.cn>
	<00fb063304a0720f3ba9db6f79bb67263d450356.1353377266.git.wei_wang@realsil.com.cn>
Date: Mon, 19 Nov 2012 21:21:31 -0500
In-Reply-To: <00fb063304a0720f3ba9db6f79bb67263d450356.1353377266.git.wei_wang@realsil.com.cn>
	(wei wang's message of "Tue, 20 Nov 2012 10:09:16 +0800")
Message-ID: <87ip91f1zo.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry to be pedantic, but:

On Mon, Nov 19 2012, wei_wang@realsil.com.cn wrote:
> For Realtek card reader, internal regsiter SD_CFG2 should be configured
> before transferring data. In the prior version, the value of this register
> has been calculated, but forgotten to write back to the internal register.

With what consequences?  Was the  data transfer failing?  Under which
circumstances?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
