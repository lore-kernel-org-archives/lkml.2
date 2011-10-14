Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab1JNOWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:22:10 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:60598 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680Ab1JNOWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:22:08 -0400
Subject: Re: [PATCH 18/21] pci: drop unused Kconfig symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1318601485.6132.91.camel@x61.thuisdomein>
References: <1318595439.6132.77.camel@x61.thuisdomein>
	 <20111014135743.GD4577@phenom.oracle.com>
	 <1318601485.6132.91.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 16:22:06 +0200
Message-ID: <1318602126.6132.99.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 16:11 +0200, Paul Bolle wrote:
> Perhaps this driver is (some part of) xen. That I didn't check. Should I
> have done that too?

Obviously, since this symbol in unused now, it's not possible to
determine what driver is involved. That would be different if this
Kconfig symbol was actually used previously. But I didn't check - for
all those symbols involved in this series - why they turned out to be
unused now. So I can't say whether these symbols should never have been
in the tree in the first place or whether they were forgotten when
someone removed their last actual usage.


Paul Bolle

