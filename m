Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab2BMADJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 19:03:09 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42602 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab2BMADH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 19:03:07 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo5_9N-HX3Ja8k04QaS6nss8SAm-NUtuQyHt0t-Dczt8-w@mail.gmail.com>
References: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
	<1328425088-6562-5-git-send-email-yinghai@kernel.org>
	<CAErSpo6=t1XtdUMBAn7Ag5XNLS3wKueybfrsUzmht6GL9XSGLQ@mail.gmail.com>
	<CAE9FiQXrFARy4+ynOTRyEuoyRxTc9qqzUaYJH8e19Wt3JRRxug@mail.gmail.com>
	<CAErSpo5_9N-HX3Ja8k04QaS6nss8SAm-NUtuQyHt0t-Dczt8-w@mail.gmail.com>
Date: Sun, 12 Feb 2012 16:03:05 -0800
X-Google-Sender-Auth: _givvFaEB8oynBTyiKTsz4G-iHE
Message-ID: <CAE9FiQV=nAK3KDUVvqiQ=otVUAHQf9GpxbR1gLvPc5ofHjOJaA@mail.gmail.com>
Subject: Re: [PATCH 04/24] PCI: Add busn_res operation functions
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 12, 2012 at 3:51 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>
>>>
>>> I think it would be better to remove the bus resource from the tree,
>>> change its "end," then re-insert it.
>>
>> how about parent buses that have extended top?
>
> I don't understand your question.  I assume you mean there's a case
> where remove/update/reinsert doesn't work, but I don't see why that
> would be a problem.  Can you show an example?

I mean parent busn_res already had several level's children busn_res.
and every level may have some siblings.
before remove will need to record those resources, to later to put them back.

that just increase not necessary complexity. because we already know
those resource could be extended safely.

Yinghai
