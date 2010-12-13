Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab0LMABR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:01:17 -0500
Received: from capside.net ([81.19.98.74]:48737 "EHLO eul0600410.eu.verio.net"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755193Ab0LMABO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 19:01:14 -0500
Date: Mon, 13 Dec 2010 01:01:06 +0100
From: =?iso-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>
To: Joe Perches <joe@perches.com>
Cc: devel@linuxdriverproject.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Staging: rt2860: include KERN_* in printk
Message-ID: <20101213000106.GA2049@bart.evergreen.loc>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	devel@linuxdriverproject.org, Greg Kroah-Hartman <gregkh@suse.de>,
	linux-kernel@vger.kernel.org
References: <1292176591-26081-1-git-send-email-agimenez@sysvalve.es>
 <1292176591-26081-4-git-send-email-agimenez@sysvalve.es>
 <1292180668.18202.43.camel@Joe-Laptop>
 <20101212192554.GA32583@bart.evergreen.loc>
 <1292183170.18202.56.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1292183170.18202.56.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 11:46:09AM -0800, Joe Perches wrote:
> On Sun, 2010-12-12 at 20:25 +0100, L. Alberto Giménez wrote:
> > On Sun, Dec 12, 2010 at 11:04:28AM -0800, Joe Perches wrote:
> > > On Sun, 2010-12-12 at 18:56 +0100, L. Alberto Giménez wrote:
> > > > diff --git a/drivers/staging/rt2860/pci_main_dev.c b/drivers/staging/rt2860/pci_main_dev.c
> > > > @@ -601,15 +600,15 @@ void hex_dump(char *str, unsigned char *pSrcBufVA, unsigned int SrcBufLen)
> > > >[...]
> > > This should use print_hex_dump
> > Ok, but I'll have to figure out how to translate the arguments without losing
> > the original developers intended format.
> 
> I think you can change the format without concern.
> 
> print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1,
> 	       pSrcBufVA, SrcBufLen, true);

Hi Joe,

If you don't mind, I will send this as a separate patch, since including it in
the KERN_* cleanup would clobber the patch and I'd prefer to make an standalone
patch for the hex_dump -> print_hex_dump modifications (many files in the source
do use the function).

Regards,
-- 
L. Alberto Giménez
JabberID agimenez@jabber.sysvalve.es
GnuPG key ID 0x3BAABDE1
