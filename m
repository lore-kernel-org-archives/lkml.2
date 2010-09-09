Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab0IIPXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 11:23:38 -0400
Received: from mail.perches.com ([173.55.12.10]:1550 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab0IIPXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 11:23:37 -0400
Subject: Re: [PATCH] include/linux/pci.h: Make struct pci_driver.name const
 char *
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100909075455.0cf3d3a5@nehalam>
References: <1284017884.24986.93.camel@Joe-Laptop>
	 <20100909075455.0cf3d3a5@nehalam>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 08:23:34 -0700
Message-ID: <1284045814.24986.119.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-09 at 07:54 -0700, Stephen Hemminger wrote:
> On Thu, 09 Sep 2010 00:38:04 -0700
> Joe Perches <joe@perches.com> wrote:
> > As far as I can tell, name is never modified.
> I already sent same patch to Jesse

Great.

I found it now on linux-pci.
https://patchwork.kernel.org/project/linux-pci/list/

I think it's better to cc lkml with patches to enable
easier searches of the patchwork queue in a single place.

https://patchwork.kernel.org/project/LKML/list/

cheers, Joe

