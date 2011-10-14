Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060Ab1JNOa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:30:59 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:59718 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab1JNOa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:30:58 -0400
Subject: Re: [PATCH 18/21] pci: drop unused Kconfig symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20111014142254.GA8887@phenom.oracle.com>
References: <1318595439.6132.77.camel@x61.thuisdomein>
	 <20111014135743.GD4577@phenom.oracle.com>
	 <1318601485.6132.91.camel@x61.thuisdomein>
	 <20111014142254.GA8887@phenom.oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 16:30:49 +0200
Message-ID: <1318602649.6132.102.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 10:22 -0400, Konrad Rzeszutek Wilk wrote:
> Why? Is it b/c PCI_DEBUG does not exist? How did you determine it is
> unused?

$ git grep -n XEN_PCIDEV_FE_DEBUG
$

So there's no other Kconfig symbol that depends in this symbol. Neitehr
is there anything that uses CONFIG_XEN_PCIDEV_FE_DEBUG.


Paul Bolle

