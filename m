Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab2HJT1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 15:27:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55196 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab2HJT1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 15:27:07 -0400
Date: Fri, 10 Aug 2012 20:26:53 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, Jan Beulich <JBeulich@suse.com>,
        Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, cJ-ko@zougloub.eu,
        "H. PeterAnvin" <hpa@zytor.com>
Subject: Re: [Regression] "x86-64/efi: Use EFI to deal with platform wall
 clock" prevents my machine from booting
Message-ID: <20120810192653.GA11641@srcf.ucam.org>
References: <20120806125216.GA11863@srcf.ucam.org>
 <501FDDD30200007800092DDE@nat28.tlf.novell.com>
 <20120806091627.2ad5ed2e@zougloub.eu>
 <20120806223208.5301be0d@zougloub.eu>
 <20120806230629.153d33bd@zougloub.eu>
 <5020DC5F02000078000931C2@nat28.tlf.novell.com>
 <1344331830.7208.6.camel@mfleming-mobl1.ger.corp.intel.com>
 <50210F0702000078000932EB@nat28.tlf.novell.com>
 <1344502295.9195.7.camel@mfleming-mobl1.ger.corp.intel.com>
 <CAE9FiQUuQAEzin2uXRXWhMXAviu8MXLDkfjFbFJMWB4xkKimFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUuQAEzin2uXRXWhMXAviu8MXLDkfjFbFJMWB4xkKimFA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 12:22:12PM -0700, Yinghai Lu wrote:

> What is solution for this regression?

Revert the patch for now, we'll add it back once we've got the UEFI 
pagetable set up.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
