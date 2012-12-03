Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab2LCVSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 16:18:01 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53470 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab2LCVR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 16:17:57 -0500
Date: Mon, 3 Dec 2012 22:17:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Ortiz, Lance E" <lance.oritz@hp.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Yanmin <yanmin.zhang@intel.com>
Subject: Re: [PATCH v3 1/3] aerdrv: Trace Event for AER
Message-ID: <20121203211754.GA15693@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Ortiz, Lance E" <lance.oritz@hp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>,
	"lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
	"jiang.liu@huawei.com" <jiang.liu@huawei.com>,
	"tony.luck@intel.com" <tony.luck@intel.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Zhang Yanmin <yanmin.zhang@intel.com>
References: <20121130213330.7649.51101.stgit@grignak.americas.hpqcorp.net>
 <20121201093614.720aa96a@redhat.com>
 <A961433CDFF2F640A2866803152E61F9516EE717@G4W3218.americas.hpqcorp.net>
 <20121203202756.GB14798@liondog.tnic>
 <A961433CDFF2F640A2866803152E61F9516EE7B0@G4W3218.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A961433CDFF2F640A2866803152E61F9516EE7B0@G4W3218.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 09:13:49PM +0000, Ortiz, Lance E wrote:
> This a fine idea. I'm thinking we might want to implement that in a
> later patch since it is a bigger change and we still need to see about
> adding additional strings.

Yes, definitely in a later patch or more depending on how much changes
are needed (haven't looked closely at the whole deal).

> I can send out one more version of the patch with the comment header
> changes you suggested, and the comments Joe had and maybe we can move
> forward with that.

Sure, thanks.

-- 
Regards/Gruss,
    Boris.
