Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab0KBB2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 21:28:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34685 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab0KBB2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 21:28:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=L0Ob88G4JxZU31q3ybPvPDjp3KZsmP102ETQHUT6QHm2r+2WtGKxYAD3jX5Kz44+61
         YGGJrwjapKYL6SPADocTmEqKdQriPuBBSdjZDl+1ncPcdCuXgKn9JjnpHFzG1HM815rk
         enN0wa2wyQj3r33PdyrNs4BzboIfwjQiJRmic=
MIME-Version: 1.0
In-Reply-To: <1288660377.20990.1.camel@mola>
References: <1288660377.20990.1.camel@mola>
Date: Mon, 1 Nov 2010 23:28:18 -0200
Message-ID: <AANLkTikmRr3_T8ObcjWgnZdsDTtE+ab=r42z+y7vb0sF@mail.gmail.com>
Subject: Re: [PATCH] dma: imx-dma: fix imxdma_probe error path
From: Thiago Farina <tfransosi@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Pengutronix <s.hauer@pengutronix.de>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 11:12 PM, Axel Lin <axel.lin@gmail.com> wrote:
> otherwise, i will be -1 inside the latest iteration of the while loop.
>
nit: s/otherwise, i will be/Otherwise, it will be ?
