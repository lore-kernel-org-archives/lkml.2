Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab1JNOyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:54:12 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:58443 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab1JNOyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:54:11 -0400
Subject: Re: [PATCH 18/21] pci: drop unused Kconfig symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
In-Reply-To: <20111014144208.GB12349@phenom.oracle.com>
References: <1318595439.6132.77.camel@x61.thuisdomein>
	 <20111014135743.GD4577@phenom.oracle.com>
	 <1318601485.6132.91.camel@x61.thuisdomein>
	 <20111014142254.GA8887@phenom.oracle.com>
	 <1318602649.6132.102.camel@x61.thuisdomein>
	 <20111014144208.GB12349@phenom.oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 16:53:55 +0200
Message-ID: <1318604035.6132.109.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 10:42 -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, Oct 14, 2011 at 04:30:49PM +0200, Paul Bolle wrote:
> > So there's no other Kconfig symbol that depends in this symbol. Neitehr
> > is there anything that uses CONFIG_XEN_PCIDEV_FE_DEBUG.
> 
> Excellent. Can you include that in the description please then.

Sure (minus my typos, of course).

> And you can also include 'Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>'
> on that patch.

Sure. That will be in a week or so. The current plan is to see what gets
NAKed and what gets merged and send the rest (with the tags they
collected in that week) to Michal Marek, who will handle the remaining
patches from there on.


Paul Bolle

