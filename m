Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab2CWV3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 17:29:36 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62606 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab2CWV3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 17:29:34 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFx+dXoJ=MGmpyzepDjBDv8LpXqdxUBCbdrakMKBsKpmTw@mail.gmail.com>
References: <20120322144817.796e3a8a@jbarnes-desktop>
	<CAE9FiQV96Uz9fU=v4=eBbAogOeehuBM3eHgSr0QW_C68ceADcQ@mail.gmail.com>
	<CA+55aFx+dXoJ=MGmpyzepDjBDv8LpXqdxUBCbdrakMKBsKpmTw@mail.gmail.com>
Date: Fri, 23 Mar 2012 14:29:33 -0700
X-Google-Sender-Auth: owgF0ten7fO3bLW7IR2TMkQ2F9Q
Message-ID: <CAE9FiQVs5+BVmn46xeXR_GwOYBkYy73-aSKYHQUv3EoTTiUtYQ@mail.gmail.com>
Subject: Re: [git pull] PCI changes (including maintainer change)
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 2:10 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Mar 23, 2012 at 12:58 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>
>> There are some merge conflicts. Hope attached patch could help Linus a
>> little bit.
>
> Hmm. My merge does not agree with yours at all in the MIPS
> pcibios_fixup_bus() area.
>
> Your patch re-introduces the device resource fixup that Bjorn removed,
> for example.
>
> I think my merge is correct, but hey, people should double-check.

yes, you are right.

Yinghai
