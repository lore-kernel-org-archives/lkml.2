Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab0FOReq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 13:34:46 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:43735 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358Ab0FORep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 13:34:45 -0400
Date: Tue, 15 Jun 2010 18:34:32 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 23/26] power: Add JZ4740 battery driver.
Message-ID: <20100615173432.GA27904@linux-mips.org>
References: <1275505397-16758-1-git-send-email-lars@metafoo.de>
 <1275505950-17334-7-git-send-email-lars@metafoo.de>
 <20100614155108.GA30552@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614155108.GA30552@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 07:51:08PM +0400, Anton Vorontsov wrote:

> On Wed, Jun 02, 2010 at 09:12:29PM +0200, Lars-Peter Clausen wrote:
> > This patch adds support for the battery voltage measurement part of the JZ4740
> > ADC unit.
> > 
> > Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> > Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> > ---
> 
> Looks good. I see this is an RFC. Do you want me to apply it
> or there's a newer version to be submitted?

To allow for reasonable testing while this patchset is getting integrated
I suggest I apply all the patches that were acked by the respective
maintainers to the MIPS tree, feed them to -next for testing  and once
that phase is complete send the whole thing to Linus.

  Ralf
