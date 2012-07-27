Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab2G0XRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 19:17:52 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63807 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab2G0XRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 19:17:50 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1207272210200.30412@pobox.suse.cz>
References: <alpine.LNX.2.00.1207210000190.21929@pobox.suse.cz>
	<alpine.LNX.2.00.1207271527550.11375@pobox.suse.cz>
	<CAHtARFHgG_8hQ85r5=W0E8d4BU-HVFLw7xkOFZA+H6kvH_83Nw@mail.gmail.com>
	<alpine.LNX.2.00.1207272210200.30412@pobox.suse.cz>
Date: Fri, 27 Jul 2012 16:17:49 -0700
Message-ID: <CAHtARFECa0090rCWuc5uH2ss7nsRvx9+bkki03TSxizbDvmX2A@mail.gmail.com>
Subject: Re: [PATCH] [RFC] [SCSI] mpt fusion: add support for 0x1000/0x0055
From: adam radford <aradford@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Eric Moore <Eric.Moore@lsi.com>,
        James Bottomley <JBottomley@parallels.com>,
        "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>,
        DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/27/12, Jiri Kosina <jkosina@suse.cz> wrote:
...
>
> So, what is the alternative?
>
> The only thing I know is that it works at least in basic mode (haven't
> tested performance at all).

The driver for your card is a closed source driver called 'megasr'.
Here is a link to the LSI download page for this card/driver:

http://www.lsi.com/support/Pages/Download-Results.aspx?productcode=P00041&assettype=0&component=Storage%20Component&productfamily=Legacy%20RAID%20Controllers&productname=MegaRAID%20SAS%208208XLP

-Adam
