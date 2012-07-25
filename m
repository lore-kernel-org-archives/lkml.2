Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab2GYWpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 18:45:33 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:13754 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab2GYWpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 18:45:31 -0400
Message-ID: <50107709.2000301@tilera.com>
Date: Wed, 25 Jul 2012 18:45:29 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] tilegx pci: fix semantic merge conflict with 3527ed81c
References: <201207251946.q6PJklUm016228@farm-0002.internal.tilera.com> <CAErSpo7P4jCw=gTDR3JabY1F46xWiTF6ru90T86NzuT7Pxu1_A@mail.gmail.com>
In-Reply-To: <CAErSpo7P4jCw=gTDR3JabY1F46xWiTF6ru90T86NzuT7Pxu1_A@mail.gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/2012 5:16 PM, Bjorn Helgaas wrote:
> On Wed, Jul 25, 2012 at 1:40 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>> > Yinghai Lu removed pci_bus.subordinate in pci-next, which meant that
>> > the tile-next changes to add tilegx PCI support don't build.  This
>> > was expected (seen in linux-next) and this one-line fix is along
>> > the same lines as commit b918c62e for all other architectures.
>> >
>> > Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
>
> You pushed the other tile changes, so I assume you'll do the same with
> this one.  

I will, thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

