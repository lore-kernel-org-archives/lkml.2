Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab2LEQa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:30:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52739 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab2LEQaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:30:23 -0500
Date: Wed, 5 Dec 2012 17:30:19 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Ortiz, Lance E" <lance.oritz@hp.com>
Cc: "bhelgaas@google.com" <bhelgaas@google.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 2/3] aerdrv: Enhanced AER logging
Message-ID: <20121205163019.GC28556@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Ortiz, Lance E" <lance.oritz@hp.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>,
	"lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
	"jiang.liu@huawei.com" <jiang.liu@huawei.com>,
	"tony.luck@intel.com" <tony.luck@intel.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"mchehab@redhat.com" <mchehab@redhat.com>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20121204210305.4515.91100.stgit@grignak.americas.hpqcorp.net>
 <20121204210312.4515.13415.stgit@grignak.americas.hpqcorp.net>
 <20121205143202.GD2364@liondog.tnic>
 <A961433CDFF2F640A2866803152E61F9516F279F@G4W3219.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A961433CDFF2F640A2866803152E61F9516F279F@G4W3219.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 04:14:14PM +0000, Ortiz, Lance E wrote:
> I removed the prefix argument because it was never used by its caller
> and never set. The reason I added the prefix variable and set it to
> NULL was to help in breaking up the patch and adding it would help the
> intermittent patch build without changing too much code. I knew I was
> actually going to use the variable in patch 3.

No, the correct way to do that is to keep all changes that belong
logically together in a single patch for ease of reviewing and avoid
breakages. And in your case this should be pretty easy: simply move all
the 'prefix' touching code to patch #3 and you're done, AFAICT.

Thanks.

-- 
Regards/Gruss,
    Boris.
