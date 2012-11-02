Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab2KBUK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 16:10:28 -0400
Received: from mail-vb0-f66.google.com ([209.85.212.66]:36251 "EHLO
	mail-vb0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab2KBUKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 16:10:25 -0400
Date: Fri, 2 Nov 2012 16:10:19 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel <xen-devel@lists.xen.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] xen-pciback: parsing improvements
Message-ID: <20121102201018.GA6786@konrad-lan.dumpdata.com>
References: <5093E84C02000078000A619F@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5093E84C02000078000A619F@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 02:35:40PM +0000, Jan Beulich wrote:
> 1: simplify and tighten parsing of device IDs
> 2: reject out of range inputs

applied for v3.8.

Thanks!
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
