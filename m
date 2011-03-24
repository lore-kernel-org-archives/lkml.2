Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab1CXMY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 08:24:27 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33642 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab1CXMY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 08:24:26 -0400
Date: Thu, 24 Mar 2011 12:24:09 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Commit 9661e92c10a9775243c1ecb73373528ed8725a10: sysfs: cannot
	create duplicate filename
	'/devices/pci0000:00/0000:00:02.0/backlight/acpi_video0/device'
Message-ID: <20110324122409.GA1564@srcf.ucam.org>
References: <Pine.LNX.4.64.1103242007300.2677@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1103242007300.2677@boston.corp.fedex.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Odd, this shouldn't register anything that wasn't previously registered. 
Can you attach the output of acpidump, dmesg and lspci?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
