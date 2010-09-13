Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab0IMSzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:55:25 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:50856 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab0IMSzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:55:24 -0400
Date: Mon, 13 Sep 2010 11:55:24 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "akpm@kernel.org" <akpm@kernel.org>
Subject: Re: [PATCH RFC 1/1] MISC: Broadcom BCM4751 GPS driver
Message-ID: <20100913185524.GB24876@hexapodia.org>
References: <1282572026-14905-1-git-send-email-matti.j.aaltonen@nokia.com> <1282572026-14905-2-git-send-email-matti.j.aaltonen@nokia.com> <1283512047.26985.119.camel@masi.mnp.nokia.com> <20100910185942.GB17794@hexapodia.org> <1284372716.12913.25.camel@masi.mnp.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284372716.12913.25.camel@masi.mnp.nokia.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 01:11:56PM +0300, Matti J. Aaltonen wrote:
> On Fri, 2010-09-10 at 20:59 +0200, ext Andy Isaacson wrote:
> > On Fri, Sep 03, 2010 at 02:07:27PM +0300, Matti J. Aaltonen wrote:
> > > On Mon, 2010-08-23 at 16:00 +0200, Aaltonen Matti.J (Nokia-MS/Tampere)
> > > wrote:
> > > > Driver for Broadcom BCM4751 GPS chip.
> > > 
> > > I sent this a while ago but didn't get any comments about the code. What
> > > do you think should something be changed or is it ready to get accepted?
> > 
> > It's unlikely to get merged if there's no public documentation of the
> > protocol it exposes, and no free codebase using the interface.
> 
> OK... I'll just mention once again that it's possible to get the
> specification for free after signing a contract with Nokia. (See:
> http://www.forum.nokia.com/info/sw.nokia.com/id/b265d3aa-8198-4eb0-a0e3-077748ccea40/MEIF_Specification_License.pdf.html)
> 
> Thank You
> Matti Aaltonen

Thanks for the link, Matti.  I unfortunately don't have time to
negotiate a legal contract with a large company, verify that the
contract does not restrict my ability to implement competing products,
write a libre implementation of a client for the API, and publish it.

If you'd like to see this driver merged, please have Nokia freely
publish a specification and a libre client -- or at the very least, an
unobfuscated libre client that can be used by kernel developers to
verify that future changes to the driver do not break the users.

For example, extending gpsd to understand your proprietary protocol
would be a good start.  http://gpsd.berlios.de/

Thanks,
-andy
