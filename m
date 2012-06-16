Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab2FPSdu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 14:33:50 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:7701 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755789Ab2FPSdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 14:33:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgsKAN3Q3E/CTtAn/2dsb2JhbABFtCMDgSyBB4IYAQEFMgFGEAsYIwsUGDGIIrgUizh6hGFgA5UjAYkkhlmCYg
Date: Sat, 16 Jun 2012 20:33:42 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [-next] FATAL: drivers/gpu/drm/udl/udl: sizeof(struct
	usb_device_id)=24 is not a modulo of the size of section
	__mod_usb_device_table=44.
Message-ID: <20120616183342.GA6873@frolo.macqel>
References: <CAMuHMdXk6pByz14JcDgY+UE6QM0sHD8cbXye9CgOVSRRtr7J+Q@mail.gmail.com> <20120615201021.GB14544@kroah.com> <CAMuHMdUj6tAcWhkSkV43Kw3-2-3+JzgP6W=2w3fjL2KBfRh9ZQ@mail.gmail.com> <20120615231220.GC8205@kroah.com> <87lijns84s.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87lijns84s.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 03:23:31PM +0200, Bjørn Mork wrote:
> 
> AFAIK (which admittedly is not much wrt cross building) there is no way
> we can make the host built file2alias know the proper aligment for the
> structure in the target built modules.  That's the background for this
> fix: 

autoconf has a lot of nice macros (using the cross-compiler) to solve
that sort  of problems.

Philippe
