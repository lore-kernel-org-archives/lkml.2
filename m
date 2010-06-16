Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892Ab0FPMUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 08:20:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46076 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab0FPMUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 08:20:47 -0400
Date: Wed, 16 Jun 2010 13:20:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
       Lars-Peter Clausen <lars@metafoo.de>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk
Subject: Re: [RFC][PATCH 23/26] power: Add JZ4740 battery driver.
Message-ID: <20100616122042.GB31387@sirena.org.uk>
References: <1275505397-16758-1-git-send-email-lars@metafoo.de> <1275505950-17334-7-git-send-email-lars@metafoo.de> <20100614155108.GA30552@oksana.dev.rtsoft.ru> <20100615173432.GA27904@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615173432.GA27904@linux-mips.org>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 06:34:32PM +0100, Ralf Baechle wrote:
> On Mon, Jun 14, 2010 at 07:51:08PM +0400, Anton Vorontsov wrote:

> > Looks good. I see this is an RFC. Do you want me to apply it
> > or there's a newer version to be submitted?

> To allow for reasonable testing while this patchset is getting integrated
> I suggest I apply all the patches that were acked by the respective
> maintainers to the MIPS tree, feed them to -next for testing  and once
> that phase is complete send the whole thing to Linus.

Due to major pending changes in the audio subsystem at least the audio
subsystem changes will have merge issues in -next from that.  To avoid
these I suggest putting the audio changes on a branch which can be
pulled into both trees.
