Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab0HCWQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 18:16:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45499 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224Ab0HCWQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 18:16:08 -0400
Date: Tue, 3 Aug 2010 23:15:37 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Huang Ying <ying.huang@intel.com>, "Tang, Feng" <feng.tang@intel.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: EFI runtime-services on x86_64
Message-ID: <20100803221537.GA4893@srcf.ucam.org>
References: <201007301458.50263.bjorn.helgaas@hp.com> <20100802103535.6442ab49@feng-i7> <1280716920.2771.1519.camel@yhuang-dev> <m14ofbgyki.fsf@fess.ebiederm.org> <20100803215346.GA4476@srcf.ucam.org> <m1lj8nfjf1.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1lj8nfjf1.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 02:58:10PM -0700, Eric W. Biederman wrote:

> Only if you have EFI runtime services enabled in your kernel.  You can
> skip the efi junk and the kernel runs just fine.  Doing what we do on
> every other platform which appears to be a combination of ACPI and
> direct hardware access appears to be good enough, and that is a path
> that actually gets tested regularly.

I think wanting to set the nvram variables so that your bootloader works 
is a pretty typical usecase...
-- 
Matthew Garrett | mjg59@srcf.ucam.org
