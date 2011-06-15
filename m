Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab1FOSbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 14:31:40 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52213 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab1FOSbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 14:31:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=SUHba6iRytHjKK8E9cobh1lqrP7ZG5y2TmfidTgYFH9l1s/DmkfpUKWqL9hzpDXQRU
         UBZUbHcK1yae0vWoB6Jw==
MIME-Version: 1.0
In-Reply-To: <20110612204406.GC30738@ram-laptop>
References: <4DEBCA3F.8050205@hartkopp.net> <BANLkTin_WHuy5MExNBHdeLiDmdmn7SZYkg@mail.gmail.com>
 <4DED05C4.7050903@hartkopp.net> <m3hb82wx6m.fsf@pullcord.laptop.org>
 <4DEE6FC6.9040308@hartkopp.net> <4DEE84AD.6050104@hartkopp.net>
 <4DEEA3CD.30507@kernel.org> <4DEF1606.5030803@hartkopp.net> <20110612204406.GC30738@ram-laptop>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 15 Jun 2011 11:31:16 -0700
Message-ID: <BANLkTi=2rricbvxhMNBrPQihxautTUvspQ@mail.gmail.com>
Subject: Re: sdhci-pci fails on 3.0.0-rc1 on Dell E6510
To: Ram Pai <linuxram@us.ibm.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>, Yinghai Lu <yinghai@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Chris Ball <cjb@laptop.org>,
        "S, Venkatraman" <svenkatr@ti.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 12, 2011 at 1:44 PM, Ram Pai <linuxram@us.ibm.com> wrote:
> Looks like the kernel; by default, tries to allocate mem resource of size
> 0x4000000 each to the BARs of the cardbus bridge. This cannot be satisfied
> meeting all the constraints. The BIOS had not allocated the resource to
> begin with.
>
> Anyone knows if the default value can be reduced to something smaller?

You can try "pci=cbmemsize=" as a workaround.  See pci_cardbus_mem_size.
