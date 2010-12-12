Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab0LLXjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:39:21 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:32884 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab0LLXjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:39:20 -0500
Date: Sun, 12 Dec 2010 23:39:05 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Igor Plyatov <plyatov@gmail.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@maxim.org.za, nicolas.ferre@atmel.com, costa.antonior@gmail.com,
        ryan@bluewatersys.com, christian.glindkamp@taskit.de,
        pgsellmann@portner-elektronik.at
Subject: Re: [PATCH v4] mach-at91: Support for gsia18s board added
Message-ID: <20101212233905.GJ8665@n2100.arm.linux.org.uk>
References: <1292000411-6691-1-git-send-email-plyatov@gmail.com> <20101212005048.GH19897@game.jcrosoft.org> <1292135848.2456.19.camel@homepc> <20101212140727.GI19897@game.jcrosoft.org> <20101212142200.GG8665@n2100.arm.linux.org.uk> <1292183570.8737.33.camel@homepc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292183570.8737.33.camel@homepc>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 10:52:50PM +0300, Igor Plyatov wrote:
> Just to clarify: my gsia18s machine number will be added into
> linux-2.6.37-rc6?

That depends on the timing of my next pull request.  I don't have that
much queued for the -rc at present, so I may skip sending stuff for rc6.
It will be in before the next merge window now though, and idIt'll be
queued in linux-next nevertheless.

> Russel, please fix it to more readable "gsia18s" and "*_GSIA18S" for my
> 3234 machine.
> Old names with two underscores ("gs_ia18_s" and "*_GS_IA18_S") was very
> hard to read in the source code.

Fixed, inspite of the spelling error above.  Grr.
