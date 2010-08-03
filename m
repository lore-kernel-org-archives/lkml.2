Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab0HCV6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 17:58:15 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39694 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757597Ab0HCV6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 17:58:14 -0400
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Huang Ying <ying.huang@intel.com>, "Tang\, Feng" <feng.tang@intel.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: EFI runtime-services on x86_64
References: <201007301458.50263.bjorn.helgaas@hp.com>
	<20100802103535.6442ab49@feng-i7>
	<1280716920.2771.1519.camel@yhuang-dev>
	<m14ofbgyki.fsf@fess.ebiederm.org>
	<20100803215346.GA4476@srcf.ucam.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Aug 2010 14:58:10 -0700
In-Reply-To: <20100803215346.GA4476@srcf.ucam.org> (Matthew Garrett's message of "Tue\, 3 Aug 2010 22\:53\:46 +0100")
Message-ID: <m1lj8nfjf1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> On Tue, Aug 03, 2010 at 02:45:33PM -0700, Eric W. Biederman wrote:
>
>> EFI runtime calls have the nasty fact that they don't work in general even
>> if EFI is present because you may have the wrong word size EFI running on
>> your machine.  A 32bit EFI and a 64bit kernel or a 64bit EFI and a 32bit kernel.
>
> You've already failed to boot in that case.

Only if you have EFI runtime services enabled in your kernel.  You can
skip the efi junk and the kernel runs just fine.  Doing what we do on
every other platform which appears to be a combination of ACPI and
direct hardware access appears to be good enough, and that is a path
that actually gets tested regularly.

Eric
