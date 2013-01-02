Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab3ABXlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 18:41:23 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:41773 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab3ABXlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 18:41:20 -0500
MIME-Version: 1.0
In-Reply-To: <1357169259.25181.9.camel@joe-AO722>
References: <20130102232730.5706.82243.stgit@grignak.americas.hpqcorp.net>
	<20130102232743.5706.63153.stgit@grignak.americas.hpqcorp.net>
	<1357169259.25181.9.camel@joe-AO722>
Date: Wed, 2 Jan 2013 15:41:19 -0800
X-Google-Sender-Auth: AkB8-GB6mAwBRfEaPk0aeerf2NQ
Message-ID: <CA+8MBbK3Ah81TCDRTqM-XV9vEtKCC1m7YCAr75NiUwPRM4OfsQ@mail.gmail.com>
Subject: Re: [PATCH v8 3/3] aerdrv: Cleanup log output for AER
From: Tony Luck <tony.luck@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Lance Ortiz <lance.ortiz@hp.com>, bhelgaas@google.com,
        lance_ortiz@hotmail.com, jiang.liu@huawei.com, bp@alien8.de,
        rostedt@goodmis.org, mchehab@redhat.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 3:27 PM, Joe Perches <joe@perches.com> wrote:
> Just use dev_err( instead of dev_printk(KERN_ERR,
> It's a function and it makes the object code smaller.

Looks like we are almost converged on a solution (Lance: thanks for
your patience and diligence in making changes).

Anyone on the "To:" list want to claim this for their tree to commit?
The series touches pci, acpi, RAS, and tracing ... so there are
several possible owners.

If someone else wants it, then add an:
Acked-by: Tony Luck <tony.luck@intel.com>
to all three parts.

If there isn't a strong claim, I'll add v9[*] to the RAS tree
and see if the TIP tree folks will pull it from me.

-Tony

[*] When Lance makes the change suggested by Joe.
