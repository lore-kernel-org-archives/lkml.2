Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab1LAJOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 04:14:48 -0500
Received: from ackle.nomi.cz ([81.31.33.35]:43723 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab1LAJOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 04:14:45 -0500
Date: Thu, 1 Dec 2011 10:14:41 +0100
From: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Wilcox <matthew@wil.cx>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: DMAR:[fault reason 02] Present bit in context entry is clear
	(firewire-ohci)
Message-ID: <20111201091441.GA32731@nomi.cz>
References: <4BF7B147.9020502@s5r6.in-berlin.de> <20100522121212.GQ10452@parisc-linux.org> <1274553643.11551.17300.camel@macbook.infradead.org> <20100522120905.154ff932@jbarnes-x201> <20111119172127.GA31915@nomi.cz> <4ED656F6.4080709@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4ED656F6.4080709@ladisch.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Nov 30, 2011 at 05:16:54PM +0100, Clemens Ladisch wrote:
> Try the patch in <https://bugzilla.redhat.com/show_bug.cgi?id=605888>
> that is intended to work around the bug in your Ricoh chip.  Alternatively,
> disable VT-d or FireWire in the BIOS, or add the kernel parameter
> "intel_iommu=off".

Yeah, I guess that would work, I was just concerned with a fix not being in
the mainline. Surely we don't expect every ThinkPad user who wants to use
firewire and VT-d to apply the patch himself (the Fedora fix was to forcefully
disable IOMMU in presence of that Ricoh device). :-)

Regards,
-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
