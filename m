Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875Ab0EABoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 21:44:44 -0400
Received: from [12.175.186.2] ([12.175.186.2]:41717 "EHLO
	vbn.0055647.lodgenet.net" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932740Ab0EABoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 21:44:39 -0400
X-Greylist: delayed 1496 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Apr 2010 21:44:36 EDT
Date: Tue, 20 Apr 2010 10:17:49 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@sony
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: MacBookPro2,2 unable too boot with the latest HEAD
In-Reply-To: <20100419145741.95688467.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004201011050.2402@sony>
References: <i2vdd18b0c31004140812i6a0e9430u68ab49b24273fe9b@mail.gmail.com> <20100419142804.3cd53666.akpm@linux-foundation.org> <4BCCCCDF.4010605@gmail.com> <20100419145741.95688467.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > the patch here fixes it for me:ACPI: EC: Limit burst to 64 bit
> > https://bugzilla.kernel.org/attachment.cgi?id=25962
> 
> hm.  I wonder how you go from a bugzilla attachment back up tot he bug
> to which it is attached?

Use "A comment contains this string" in bugzilla's advanced search
and plug in "attachment.cgi?id=25962" for this case.

you'll find the patch in this comment:
https://bugzilla.kernel.org/show_bug.cgi?id=15749#c7

It is a bit more user friendly to supply the
URL of the commment containing the patch rather than
the direct URL of the attachment itself.

> Oh well.  Alexey, I trust that patch is in the 2.6.34 queue?

it shipped in 2.6.34-rc5 in commit 
2060c44576c79086ff24718878d7edaa7384a985

thanks,
Len Brown, Intel Open Source Technology Center

