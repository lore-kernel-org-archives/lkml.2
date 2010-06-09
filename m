Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab0FIXbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 19:31:06 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:1301 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab0FIXbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 19:31:04 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai.lu@oracle.com>
Subject: Re: [PATCH -v2] pci: clear bridge resource size if BIOS assign bad one
Date: Wed, 9 Jun 2010 17:30:31 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Yannick Roehlly <yannick.roehlly@free.fr>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <bug-16009-13546@https.bugzilla.kernel.org/> <201006081649.00332.bjorn.helgaas@hp.com> <4C0ED401.6060800@oracle.com>
In-Reply-To: <4C0ED401.6060800@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006091730.32724.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 08, 2010 05:36:33 pm Yinghai Lu wrote:
> On 06/08/2010 03:48 PM, Bjorn Helgaas wrote:
> > On Tuesday, June 08, 2010 03:43:50 pm Jesse Barnes wrote:
> > 
> > In this case, the aperture *size* from the BIOS is actually OK, but
> > the beginning of the aperture overlaps system memory.  With Yinghai's
> > patch, we reduce the size and move the start.  Windows was able to
> > just move the start of the aperture and preserve the original
> > 0x20000000 size (but I think it had to move something else out of
> > the way).
> 
> are you sure? that looks more aggressive.

I don't have the machine and can't be 100% sure, but based on what
Yannic reported here: https://bugzilla.kernel.org/show_bug.cgi?id=16009#c11,
it looks like Windows moved that aperture.

I haven't used it myself, but possibly a program like SIV
(http://rh-software.com/) would give more detailed information
about what Windows is doing.

Bjorn
