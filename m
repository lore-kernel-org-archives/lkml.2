Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab2E1Qhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 12:37:43 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45275 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab2E1Qhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 12:37:40 -0400
Date: Mon, 28 May 2012 18:37:27 +0200
From: Andi Shyti <andi.shyti@gmail.com>
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        peterhuewe@gmx.de, oatilla@gmail.com
Subject: Re: [PATCH] tpm: check the chip reference before using it
Message-ID: <20120528163727.GA6178@andi>
Mail-Followup-To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
	tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	peterhuewe@gmx.de, oatilla@gmail.com
References: <172ab3cfdd755d047e6366cc56b942820e02ffee.1338221569.git.andi.shyti@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172ab3cfdd755d047e6366cc56b942820e02ffee.1338221569.git.andi.shyti@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 28, 2012 at 06:23:12PM +0200, Andi Shyti wrote:
>  void tpm_dev_release(struct device *dev)
>  {
> +	if (!chip)
> +		return;
> +
>  	struct tpm_chip *chip = dev_get_drvdata(dev);

sorry wrong patch file... this is not going to work...
I'll resend it

Andi
