Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab0LNJUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 04:20:51 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48486 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330Ab0LNJUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 04:20:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=DxTQMjb48qO9xqk6psYx/XwU5r2kBDw3AYaLdjjiRaBu8ocUY0k9ALGyw1lmO4ulsM
         m0f35lqLUr/z4L2c1ojI8ZdnbhEj3fElN/qI4nD0DnnLJbszBAWAHdlMthgJMQNV8jlL
         kM/O3v+uHuJHEVwgWHNO9eSrdl/kEOHk6bCgQ=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTinarEEaJMLORBV9YozJ3GnFFVMJ-NOQhzRVJ0en@mail.gmail.com>
References: <AANLkTimahUpEL3cV6pFhkN8KqrphfVMSOw8xAN2=9jPy@mail.gmail.com>
	<AANLkTinarEEaJMLORBV9YozJ3GnFFVMJ-NOQhzRVJ0en@mail.gmail.com>
Date: Tue, 14 Dec 2010 10:20:41 +0100
Message-ID: <AANLkTi=0B2MHz-8ENz4+enkuB3KivPobLwaEc_BFEhQb@mail.gmail.com>
Subject: Re: [PATCH 0/13] ACPI / PM: Rework power resources management
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, len.brown@intel.com,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 4:43 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> Hi Rafael,
>
> nice to see your patchset is in linux-next (next-20101213) now.
> More precisely in linux-acpi-2.6: 1/13 + 2/13 in release and rest/13
> in test GIT branch.
>
> What about the fix
> "Platform-x86-Make-fujitsu_laptop-use-acpi_bus_update_power.patch"
> [1]?
> Will this go over platform-x86/linux-next into linux-next GIT tree?
> Are you co-ordinating this with mjg?
>
> Regards,
> - Sedat -
>
> [1] https://patchwork.kernel.org/patch/357422/
> [2] http://git.kernel.org/?p=linux/kernel/git/mjg59/platform-drivers-x86.git;a=shortlog;h=refs/heads/linux-next
>

Thanks, the patch is now included in linux-next (next-20101214) (see [1]).

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git;a=commit;h=5fd12c41e206d6bfda6eef1ed50e995a293e0777
