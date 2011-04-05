Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab1DEM16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 08:27:58 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53431 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752904Ab1DEM14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 08:27:56 -0400
Message-Id: <1302006475.6449.1437647773@webmail.messagingengine.com>
X-Sasl-Enc: FzpKYNOh0sKxnjupBFAE7nqlvqCUwt6zuKknoCGss3FK 1302006475
From: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
To: "Matthew Garrett" <mjg@redhat.com>, "Joe Perches" <joe@perches.com>
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, sedat.dilek@gmail.com,
        linux-next@vger.kernel.org, "LKML" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86" <platform-driver-x86@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
References: <BANLkTikr62YPeDnkL3DKA1Nts5aRFxsO6Q@mail.gmail.com><20110404122225.GA15883@srcf.ucam.org><1301921369.1941.29.camel@Joe-Laptop>
 <20110404130036.GB16669@srcf.ucam.org>
Subject: Re: linux-next: Tree for April 4 [BROKEN thinkpad_acpi]
In-Reply-To: <20110404130036.GB16669@srcf.ucam.org>
Date: Tue, 05 Apr 2011 09:27:55 -0300
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Apr 2011 14:00 +0100, "Matthew Garrett" <mjg@redhat.com> wrote:
> On Mon, Apr 04, 2011 at 05:49:29AM -0700, Joe Perches wrote:
> 
> > It's vdbg_printk no_printk verification.
> > 
> > #ifdef CONFIG_THINKPAD_ACPI_DEBUG
> > #define vdbg_printk dbg_printk
> > static const char *str_supported(int is_supported);
> > #else
> > #define vdbg_printk(a_dbg_level, format, arg...)	\
> > 	no_printk(format, ##arg)
> > #endif
> > 
> > Two ways to handle this.
> > 
> > 1: add
> > static inline const char *str_supported(int is_supported) { return ""; }
> > to the #else
> > 
> > 2: Remove no_printk verification and return it to do {} while (0)
> > 
> > Do you have a preference?
> 
> I don't. Henrique?

No set preference, either way is fine.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

