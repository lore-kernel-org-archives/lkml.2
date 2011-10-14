Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab1JNOLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:11:38 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:48565 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab1JNOLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:11:36 -0400
Subject: Re: [PATCH 18/21] pci: drop unused Kconfig symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20111014135743.GD4577@phenom.oracle.com>
References: <1318595439.6132.77.camel@x61.thuisdomein>
	 <20111014135743.GD4577@phenom.oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 16:11:25 +0200
Message-ID: <1318601485.6132.91.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 09:57 -0400, Konrad Rzeszutek Wilk wrote:
> Can you provide a commit message describing why?

I'm afraid there's not much more to be said than I did in the summary:
this drops an unused Kconfig symbol. 

> And can you also use scripts/get_maintainer.pl in the future
> to copy the maintainer of this driver as well?

I actually did:
$ git format-patch --stdout -1 ec9f7a5 | scripts/get_maintainer.pl 
Jesse Barnes <jbarnes@virtuousgeek.org> (supporter:PCI SUBSYSTEM)
linux-pci@vger.kernel.org (open list:PCI SUBSYSTEM)
linux-kernel@vger.kernel.org (open list)

Perhaps this driver is (some part of) xen. That I didn't check. Should I
have done that too?


Paul Bolle

