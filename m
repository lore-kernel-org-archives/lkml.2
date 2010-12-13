Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab0LMPnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:43:21 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60095 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab0LMPnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:43:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=Htw0ua0eO3qGKxMtswoRiIQD8U4nAs3EYbjPBr23L2i0Sr4Q1n8tZnIpoy9e1SAWHz
         9bGNj3neUERtVjHNs9nEQHBzPqPMKRKXawthpWUG9xVbw0BsjIaXNB+iwBdPSkRsky2r
         CH4Q0KN9Jr3muKD1UsVfzGFU68XFlM9jUab5k=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTimahUpEL3cV6pFhkN8KqrphfVMSOw8xAN2=9jPy@mail.gmail.com>
References: <AANLkTimahUpEL3cV6pFhkN8KqrphfVMSOw8xAN2=9jPy@mail.gmail.com>
Date: Mon, 13 Dec 2010 16:43:18 +0100
Message-ID: <AANLkTinarEEaJMLORBV9YozJ3GnFFVMJ-NOQhzRVJ0en@mail.gmail.com>
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

Hi Rafael,

nice to see your patchset is in linux-next (next-20101213) now.
More precisely in linux-acpi-2.6: 1/13 + 2/13 in release and rest/13
in test GIT branch.

What about the fix
"Platform-x86-Make-fujitsu_laptop-use-acpi_bus_update_power.patch"
[1]?
Will this go over platform-x86/linux-next into linux-next GIT tree?
Are you co-ordinating this with mjg?

Regards,
- Sedat -

[1] https://patchwork.kernel.org/patch/357422/
[2] http://git.kernel.org/?p=linux/kernel/git/mjg59/platform-drivers-x86.git;a=shortlog;h=refs/heads/linux-next
