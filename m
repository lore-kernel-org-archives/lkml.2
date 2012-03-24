Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab2CXBmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 21:42:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010Ab2CXBmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 21:42:10 -0400
From: Thomas Renninger <trenn@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via initrd
Date: Sat, 24 Mar 2012 02:42:06 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.10-0.4-desktop; KDE/4.4.4; x86_64; ; )
Cc: eric.piel@tremplin-utc.net, vojcek@tlen.pl, dsdt@gaugusch.at,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com
References: <1332512984-79664-1-git-send-email-trenn@suse.de> <4F6CD79A.8020805@zytor.com>
In-Reply-To: <4F6CD79A.8020805@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203240242.07724.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 March 2012 21:05:46 H. Peter Anvin wrote:
> On 03/23/2012 07:29 AM, Thomas Renninger wrote:
> > Details can be found in:
> > Documentation/acpi/initrd_table_override.txt
> 
> I did not see in this any discussion about how the data format of the
> initrd/initramfs gets affected.  There are some other things too
> (microcode updates, for example)
Interesting.

> which also would like to get initramfs
> data early, and maybe we need to think about how to containerize this
> properly.
Sounds as if this would get a bigger discussion...

I won't be able to come up with a detailed suggestion for such a general
initrd format change (that's what you suggest?).
I'd be interested to be put to CC and join the discussion, though.
This patch only slightly touches x86 initrd specifics:
(with Yinhai additions even 3 lines less):
 arch/x86/kernel/setup.c                      |   15 ++
 arch/x86/mm/init.c                           |    4 
No general initrd code is touched at all, all the rest sits in
drivers/acpi/

If there is any initrd change this could easily be adopted.
Would be great to see this one pushed into 3.4 before a possibly long
taking discussion about bigger initrd layout changes.

Thanks,

   Thomas
