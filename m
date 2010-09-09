Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab0IIOy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 10:54:59 -0400
Received: from mail.vyatta.com ([76.74.103.46]:46860 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286Ab0IIOy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 10:54:57 -0400
Date: Thu, 9 Sep 2010 07:54:55 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Joe Perches <joe@perches.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] include/linux/pci.h: Make struct pci_driver.name const
 char *
Message-ID: <20100909075455.0cf3d3a5@nehalam>
In-Reply-To: <1284017884.24986.93.camel@Joe-Laptop>
References: <1284017884.24986.93.camel@Joe-Laptop>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Sep 2010 00:38:04 -0700
Joe Perches <joe@perches.com> wrote:

> As far as I can tell, name is never modified.
> 
> This would allow names to be assigned
> from variables in non-writable sections.
> 
> static const foo[] = "bar";
> 
> struct pci_driver baz = {
> 	.name = foo;
> };
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---

I already sent same patch to Jesse
