Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab2FLVWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 17:22:05 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:43303 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab2FLVWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 17:22:04 -0400
Date: Tue, 12 Jun 2012 18:21:53 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Andi Shyti <andi.shyti@gmail.com>
Cc: debora@linux.vnet.ibm.com, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, peterhuewe@gmx.de, oatilla@gmail.com,
        key@linux.vnet.ibm.com
Subject: Re: [PATCH v2] tpm: check the chip reference before using it
Message-ID: <20120612212152.GA5190@localhost.watson.ibm.com>
References: <ceaabebd8265ee107c7237e4f69d9f0852e69ae9.1338222878.git.andi.shyti@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ceaabebd8265ee107c7237e4f69d9f0852e69ae9.1338222878.git.andi.shyti@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061221-9254-0000-0000-000009462D1C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2012, Andi Shyti wrote:

> If a driver calls tpm_dev_vendor_release for a device already released
> then the driver will oops.
> 
> Signed-off-by: Andi Shyti <andi.shyti@gmail.com>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Thanks Andi, putting in a git pull request.

Rajiv




































