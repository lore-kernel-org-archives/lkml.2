Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab3ACPu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 10:50:56 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55104 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426Ab3ACPux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 10:50:53 -0500
Date: Thu, 3 Jan 2013 16:51:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: Joe Perches <joe@perches.com>, Lance Ortiz <lance.ortiz@hp.com>,
        bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        rostedt@goodmis.org, mchehab@redhat.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/3] aerdrv: Cleanup log output for AER
Message-ID: <20130103155103.GE10243@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>, Joe Perches <joe@perches.com>,
	Lance Ortiz <lance.ortiz@hp.com>, bhelgaas@google.com,
	lance_ortiz@hotmail.com, jiang.liu@huawei.com, rostedt@goodmis.org,
	mchehab@redhat.com, linux-acpi@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20130102232730.5706.82243.stgit@grignak.americas.hpqcorp.net>
 <20130102232743.5706.63153.stgit@grignak.americas.hpqcorp.net>
 <1357169259.25181.9.camel@joe-AO722>
 <CA+8MBbK3Ah81TCDRTqM-XV9vEtKCC1m7YCAr75NiUwPRM4OfsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+8MBbK3Ah81TCDRTqM-XV9vEtKCC1m7YCAr75NiUwPRM4OfsQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 03:41:19PM -0800, Tony Luck wrote:
> On Wed, Jan 2, 2013 at 3:27 PM, Joe Perches <joe@perches.com> wrote:
> > Just use dev_err( instead of dev_printk(KERN_ERR,
> > It's a function and it makes the object code smaller.
> 
> Looks like we are almost converged on a solution (Lance: thanks for
> your patience and diligence in making changes).
> 
> Anyone on the "To:" list want to claim this for their tree to commit?
> The series touches pci, acpi, RAS, and tracing ... so there are
> several possible owners.
> 
> If someone else wants it, then add an:
> Acked-by: Tony Luck <tony.luck@intel.com>
> to all three parts.

Ditto.

Acked-by: Borislav Petkov <bp@alien8.de>

Thanks.

-- 
Regards/Gruss,
Boris.
