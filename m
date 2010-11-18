Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010Ab0KRPas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:30:48 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46166 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676Ab0KRPar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:30:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=I7p7dqJL2PCOcE6d96R1VSB2m9YZ5BKlMvzHZQmW4p67+ItG9nxvsrL6pCyRXt0nNm
         JdLaYP449/79iYWEi12tUBWVsiZBlIJuSvnefGbtZcU0Sioo+X/5WbT2YKZLLRQqjiAo
         8HPq8FnbTxqub3Zz1W0O6UlZKb6310QT/0PzU=
MIME-Version: 1.0
In-Reply-To: <20101117130018.432b0ec8@jbarnes-desktop>
References: <201011172153.11313.maciej.rutecki@gmail.com>
	<20101117130018.432b0ec8@jbarnes-desktop>
Date: Thu, 18 Nov 2010 15:30:46 +0000
X-Google-Sender-Auth: zTPNDVJH-5wXU7hI_lrgtHK0yLY
Message-ID: <AANLkTindUWKKQWtjrt0=5kx-OSsC07zkcdDMbzELb2ey@mail.gmail.com>
Subject: Re: [Regression] [2.6.37-rc2] WARNING: at drivers/pci/pci-sysfs.c:758 pci_mmap_resource+0x133/0x190()
From: Andy Whitcroft <apw@canonical.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: maciej.rutecki@gmail.com, linux-kernel <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, martin.wilck@ts.fujitsu.com,
        Andy Whitcroft <apw@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 9:00 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Wed, 17 Nov 2010 21:53:10 +0100
> Maciej Rutecki <maciej.rutecki@gmail.com> wrote:
>
>> Last known good: 2.6.37-rc1
>> Bad kernel: 2.6.37-rc2
>> Hardware: VirtualBox
>
> Should be fixed in master now, please re-test.

We also had this reported in Ubuntu[1], I have applied the commit you
suggested to the Ubuntu kernel and have confirmed that this is
resolved for my reporters:

  commit 8c05cd08a7504b855c265263e84af61aabafa329
  Author: Darrick J. Wong <djwong@us.ibm.com>
  Date:   Tue Nov 16 09:13:41 2010 -0800

    PCI: fix offset check for sysfs mmapped files

-apw

[1] http://bugs.launchpad.net/bugs/676963
