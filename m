Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab0FGDd4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 23:33:56 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20841 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab0FGDdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 23:33:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type;
	b=ywU8+73MN3ZT4T4qz0pcM7lzXnWPGVIDSNEvdLEMhdA01U4nTMs7VU2+t8A4QvKbS
	ZKty1jpz7cU4EOKALuxIQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTikgWif5ACj4Zm_4eFbx5cAipxMHd5vR4wcYePEZ@mail.gmail.com>
References: <AANLkTikgWif5ACj4Zm_4eFbx5cAipxMHd5vR4wcYePEZ@mail.gmail.com>
Date: Sun, 6 Jun 2010 20:33:49 -0700
Message-ID: <AANLkTinrRP_GYZiFRv_WzLnS_XGc9f0n-4V9GfZ-WVBQ@mail.gmail.com>
Subject: Re: Unable to boot after "ACPI: Don't let acpi_pad needlessly mark 
	TSC unstable"
From: Venkatesh Pallipadi <venki@google.com>
To: Tom Gundersen <teg@jklm.no>
Cc: Shaohua Li <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Chen Gong <gong.chen@linux.intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 6, 2010 at 6:00 PM, Tom Gundersen <teg@jklm.no> wrote:
> Hi Venkatesh,
>
> It looks like your commit 0dc698b93f3eecdda43b22232131324eb41e510c
> causes init to segfault on one of my computers.
>

Hi Tom,

Hmm... Do you have the actual message you see on fault?
Does the problem happen at the boot time?

> Reverting 0dc698b9 on top of 2.6.35-rc2 solves the problem.
>
> Let me know if you would like more details or if I can help with testing.

If you can provide some addittional info above and 'dmesg'  from no
error case (with this revert) and put them all in a bug at
bugzilla.kernel.org under ACPI, it will be great.

Thanks,
Venki
