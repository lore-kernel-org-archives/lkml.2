Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab0JOOJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:09:13 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:54278 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755590Ab0JOOJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:09:11 -0400
Date: Fri, 15 Oct 2010 15:08:19 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Julia Lawall <julia@diku.dk>
Cc: Pat Gefre <pfg@sgi.com>, kernel-janitors@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] drivers/serial/ioc3_serial.c: Return -ENOMEM on
 memory allocation failure
Message-ID: <20101015140819.GA3163@linux-mips.org>
References: <1287147610-8041-6-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287147610-8041-6-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 03:00:09PM +0200, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> In this code, 0 is returned on memory allocation failure, even though other
> failures return -ENOMEM or other similar values.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)

Dunno why linux-mips rsp. myself keep receiving patches for the ioc3 serial
driver - it's only being used on SGI IA64 machines.

Either way, I'm willing to funnel this patch upstream - I'm building a
pull rq for tonight anyway.

  Ralf
