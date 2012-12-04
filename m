Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab2LDUgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 15:36:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45852 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab2LDUgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 15:36:44 -0500
Date: Tue, 4 Dec 2012 21:36:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "Ortiz, Lance E" <lance.oritz@hp.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 2/3] aerdrv: Enhanced AER logging
Message-ID: <20121204203640.GB6242@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"Ortiz, Lance E" <lance.oritz@hp.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>,
	"lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
	"jiang.liu@huawei.com" <jiang.liu@huawei.com>,
	"tony.luck@intel.com" <tony.luck@intel.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20121204170429.31397.50068.stgit@grignak.americas.hpqcorp.net>
 <20121204170436.31397.40857.stgit@grignak.americas.hpqcorp.net>
 <20121204164151.66b9bb37@redhat.com>
 <A961433CDFF2F640A2866803152E61F9516EEACD@G4W3218.americas.hpqcorp.net>
 <20121204183110.3de876de@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121204183110.3de876de@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 06:31:10PM -0200, Mauro Carvalho Chehab wrote:
> However, in this particular case, if PCI AER got an error, but the
> device is not found when trying to handle it, it can be an indication
> that the PCI device has a more serious issue. So, I'm in favor
> of changing it, and likely be more verbose at the error message,
> saying that the device was not found while trying to report an error
> condition that happened there. It could make sense to even send a
> trace for the daemon to be aware of the error, on some pci device that
> vanished likely due to the error.

Let's leave it at pr_err now and if we actually start seeing errors like
that and decide that they need more verbose reporting, then to change it
to whatever's best. IOW, do the empirical approach.

Thanks.

-- 
Regards/Gruss,
    Boris.
