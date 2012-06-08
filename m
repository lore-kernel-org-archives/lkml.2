Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761260Ab2FHP2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:28:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55444 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757036Ab2FHP2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:28:46 -0400
Message-ID: <1339169324.20924.1.camel@joe2Laptop>
Subject: Re: [PATCH 3/7] drivers/usb/gadget/pch_udc.c: adjust suspicious bit
 operation
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>,
        Sergei Shtylyov <sshtylyov@mvista.com>, Felipe Balbi <balbi@ti.com>,
        kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia@diku.dk>
Date: Fri, 08 Jun 2012 08:28:44 -0700
In-Reply-To: <20120608125859.GO4400@mwanda>
References: <1339018901-28439-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1339018901-28439-4-git-send-email-Julia.Lawall@lip6.fr>
	 <4FD0A5F9.9050405@mvista.com> <alpine.DEB.2.02.1206071622350.1807@hadrien>
	 <1339081544.6009.44.camel@joe2Laptop> <20120608125859.GO4400@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 15:58 +0300, Dan Carpenter wrote:
> On Thu, Jun 07, 2012 at 08:05:44AM -0700, Joe Perches wrote:
> > I should have let you know that I already submitted
> > a patch series for a simple treewide
> > "s/if (value | UC_CONSTANT)/if (value & UC_CONSTANT)/"
> > https://lkml.org/lkml/2012/5/30/625
> You could CC them to kernel-janitors@vger.kernel.org.

Hi Dan,

Generally I submit patches to maintainers.
All of these 4 patches were picked up by them.

cheers, Joe

