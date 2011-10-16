Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab1JPMDj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 08:03:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63512 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab1JPMDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 08:03:38 -0400
Subject: Re: [PATCH v2] mtd: provide an alias for the redboot module name
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andres Salomon <dilinger@queued.net>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Sun, 16 Oct 2011 15:03:13 +0300
In-Reply-To: <20111014073320.140fb4b2@debxo>
References: <20111014073320.140fb4b2@debxo>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1318766597.2935.20.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 07:33 -0700, Andres Salomon wrote:
> parse_mtd_partitions takes a list of partition types; if the driver
> isn't loaded, it attempts to load it, and then it grabs the partition
> parser.  For redboot, the module name is "redboot.ko", while the parser
> name is "RedBoot".  Since modprobe is case-sensitive, attempting to
> modprobe "RedBoot" will never work.  I suspect the embedded systems that
> make use of redboot just always manually loaded redboot prior to loading
> their specific nand chip drivers (or statically compiled it in).
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>
> Cc: stable@kernel.org
> ---
>  drivers/mtd/redboot.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> v2: instead of renaming the module, use a module_alias.  Duh.  Thanks,
> Artem Bityutskiy!

Pushed to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

