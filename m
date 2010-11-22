Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0KVE4L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 23:56:11 -0500
Received: from tomasu.net ([64.85.170.234]:49209 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013Ab0KVE4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 23:56:10 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: missing 700 MB of RAM
Date: Sun, 21 Nov 2010 21:55:59 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        linux-kernel@vger.kernel.org
References: <icbqak$32o$1@ID-44327.news.uni-berlin.de> <4CE9A5D0.4080701@gmail.com>
In-Reply-To: <4CE9A5D0.4080701@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011212156.00189.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On November 21, 2010, Jiri Slaby wrote:
> On 11/21/2010 08:02 PM, Andreas Hartmann wrote:
> > I've got 8 GB RAM installed, but linux reports 7,3 GB. Where is the
> > missing RAM (700 MB)?
> 
> ...
> 
> > The motherboard is a GA-MA78GM-S2H (64bit, AMD) with a on board Radeon
> > HD 3200 VGA card. The card uses 256 MB of RAM - so 444 MB of RAM are
> > missing. Where are they gone?
> 
> Hi, ask your BIOS:
> > BIOS-provided physical RAM map:
> > BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
> > BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
> > BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> > BIOS-e820: 0000000000100000 - 00000000afde0000 (usable)
> > BIOS-e820: 00000000afde0000 - 00000000afde3000 (ACPI NVS)
> > BIOS-e820: 00000000afde3000 - 00000000afdf0000 (ACPI data)
> > BIOS-e820: 00000000afdf0000 - 00000000afe00000 (reserved)
> > BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> > BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> > BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
> 
> It reports 7677M of usable mem. Or maybe your loader is cheating on you?
> I doubt so...
> 
> regards,

I've got the same board, It doesn't seem my map is missing more than a few MB 
out of 2G (gfx reservation is 128MB)

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000077de0000 (usable)
[    0.000000]  BIOS-e820: 0000000077de0000 - 0000000077de3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000077de3000 - 0000000077df0000 (ACPI data)
[    0.000000]  BIOS-e820: 0000000077df0000 - 0000000077e00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)

I'm using the F5 bios if it helps any.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
