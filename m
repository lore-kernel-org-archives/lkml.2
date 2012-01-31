Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab2AaS45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 13:56:57 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50025 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab2AaS4z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 13:56:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo54k=pL1P1z7OetC1qJbsH9LH0GY4QFy-=PPKR0vF14SA@mail.gmail.com>
References: <1327995772-11388-1-git-send-email-yinghai@kernel.org>
	<CAErSpo54k=pL1P1z7OetC1qJbsH9LH0GY4QFy-=PPKR0vF14SA@mail.gmail.com>
Date: Tue, 31 Jan 2012 10:56:54 -0800
X-Google-Sender-Auth: HVkST2JcIXSYYHVJPDRVDjECc0o
Message-ID: <CAE9FiQUYYsfUAi-jy1uQ0V8W0mHF1eTRnHQPK46cajLvPgmR5A@mail.gmail.com>
Subject: Re: [PATCH -v3 0/14] PCI: allocate pci bus num range for unassigned
 bridge busn
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 9:49 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Mon, Jan 30, 2012 at 11:42 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> could be found at:
>>        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-busn-alloc
>>
>> -v2: according to Jesse, split to more small patches.
>> -v3: address some request from Bjorn. like make use %pR for busn_res debug print
>>        out, and move the comment change with code change.
>
> I don't see v3 in that git tree; maybe it needs to be pushed?

yeah. forgot to push.

should be there now.

Yinghai
