Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab2JIGRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:17:47 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:56555 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752410Ab2JIGRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:17:44 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Len Brown <lenb@kernel.org>
Subject: Re: [bisected] PS/2 keyboard and mouse dead on resume on Intel D845BG
Date: Tue, 9 Oct 2012 08:17:00 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Matthew Garrett <mjg@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
References: <201210071513.27959.linux@rainbow-software.org> <20121008144243.GC5068@srcf.ucam.org> <5073B21B.4090600@kernel.org>
In-Reply-To: <5073B21B.4090600@kernel.org>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201210090817.00538.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2012, Len Brown wrote:
> On 10/08/2012 10:42 AM, Matthew Garrett wrote:
> > On Sun, Oct 07, 2012 at 09:00:09PM +0200, Ondrej Zary wrote:
> >> Added acpi_read_bit_register there and it seems that SCI_EN is already
> >> set!
> >>
> >> This patch fixes the problem here. I wonder how this affects systems
> >> that require SCI_EN to be set.
> >
> > I /think/ that this will be safe, but it doesn't match my recollection
> > of how Windows behaves so it may break something. Any chance you can
> > find someone with one of the machines mentioned in
> > https://bugzilla.kernel.org/show_bug.cgi?id=13745 and make sure that
> > they still work with your patch?
>
> yikes.
> we started with a white-list,
> then we made setting SCI_EN the default,
> and here is at least one box that wants to be on a black list
> so that we don't set SCI_EN:-(

I wonder what Windows does here. Haven't tested it on this machine but I 
assume that it works.

-- 
Ondrej Zary
