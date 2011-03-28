Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab1C1QDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:03:06 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52037 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab1C1QDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:03:04 -0400
Date: Mon, 28 Mar 2011 17:02:41 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alessandro Suardi <alessandro.suardi@gmail.com>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Commit 9661e92c10a9775243c1ecb73373528ed8725a10: sysfs: cannot
 create duplicate filename
 '/devices/pci0000:00/0000:00:02.0/backlight/acpi_video0/device'
Message-ID: <20110328160241.GA20992@srcf.ucam.org>
References: <Pine.LNX.4.64.1103242007300.2677@boston.corp.fedex.com>
 <20110324122409.GA1564@srcf.ucam.org>
 <AANLkTinKrG-N8O4_qf4SWuZ+W6VvFhyyLEw2ht0PFKSo@mail.gmail.com>
 <BANLkTimPvW0Y5yqaW7WngOghhZGafVZS6w@mail.gmail.com>
 <20110328125319.GA28847@srcf.ucam.org>
 <AANLkTik0Zt=ecj-p6GBSWwQMopE7GvmFV7b7jRv=y7yJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik0Zt=ecj-p6GBSWwQMopE7GvmFV7b7jRv=y7yJ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 08:22:05AM -0700, Linus Torvalds wrote:
> On Mon, Mar 28, 2011 at 5:53 AM, Matthew Garrett <mjg@redhat.com> wrote:
> >
> > I just sent a patch to fix this.
> 
> Grr. Any more details, please? Who to? What's the fix? Actual patch
> for reporters to validate?

Sorry, yes - https://patchwork.kernel.org/patch/668351/

-- 
Matthew Garrett | mjg59@srcf.ucam.org
