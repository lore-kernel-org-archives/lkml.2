Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab0E1TZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 15:25:42 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:38146 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754695Ab0E1TZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 15:25:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WhTejtL4fzSKCmW1bINYDki4uDbHbJJd1rFXTYNIHS7Bv0HAKt1bcQTwSZWZbCQkF8ZYUZ1FjDWq8k82UpxAAFTURGfyqFBcrBjOXH3FX+AHTWP/4P9LFNSvjzciPyBT;
Date: Fri, 28 May 2010 12:25:12 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       stable <stable@kernel.org>
Subject: Re: [PATCH] pci: disable MSI on VIA K8M800
Message-ID: <20100528122512.428d4723@virtuousgeek.org>
In-Reply-To: <4BF8E5DF.6030408@kernel.org>
References: <4BF8E5DF.6030408@kernel.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 May 2010 10:22:55 +0200
Tejun Heo <tj@kernel.org> wrote:

> MSI delivery from on-board ahci controller doesn't work on K8M800.  At
> this point, it's unclear whether the culprit is with the ahci
> controller or the host bridge.  Given the track record and considering
> the rather minimal impact of MSI, disabling it seems reasonable.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Rainer Hurtado Navarro <publio.escipion.el.africano@gmail.com>
> Cc: stable@kernel.org
> ---

Applied to my for-linus branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
