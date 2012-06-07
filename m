Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761053Ab2FGPFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 11:05:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60771 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761024Ab2FGPFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 11:05:45 -0400
Message-ID: <1339081544.6009.44.camel@joe2Laptop>
Subject: Re: [PATCH 3/7] drivers/usb/gadget/pch_udc.c: adjust suspicious bit
 operation
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, Felipe Balbi <balbi@ti.com>,
        kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia@diku.dk>
Date: Thu, 07 Jun 2012 08:05:44 -0700
In-Reply-To: <alpine.DEB.2.02.1206071622350.1807@hadrien>
References: <1339018901-28439-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1339018901-28439-4-git-send-email-Julia.Lawall@lip6.fr>
	 <4FD0A5F9.9050405@mvista.com> <alpine.DEB.2.02.1206071622350.1807@hadrien>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 16:23 +0200, Julia Lawall wrote:
> Oops, thanks for noticing that.  I'll send a corrected version.

Hi Julia.

I should have let you know that I already submitted
a patch series for a simple treewide
"s/if (value | UC_CONSTANT)/if (value & UC_CONSTANT)/"
https://lkml.org/lkml/2012/5/30/625

Felipe has already picked this patch up.
https://lkml.org/lkml/2012/6/1/83



