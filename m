Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab2HUOQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 10:16:54 -0400
Received: from mga10.intel.com ([192.55.52.92]:28706 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751813Ab2HUOQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 10:16:52 -0400
Subject: Re: [Regression] "x86-64/efi: Use EFI to deal with platform wall
 clock" prevents my machine from booting
From: Matt Fleming <matt.fleming@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Jan Beulich <JBeulich@suse.com>,
        Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, cJ-ko@zougloub.eu,
        "H. PeterAnvin" <hpa@zytor.com>
In-Reply-To: <20120810192653.GA11641@srcf.ucam.org>
References: <20120806125216.GA11863@srcf.ucam.org>
	 <501FDDD30200007800092DDE@nat28.tlf.novell.com>
	 <20120806091627.2ad5ed2e@zougloub.eu> <20120806223208.5301be0d@zougloub.eu>
	 <20120806230629.153d33bd@zougloub.eu>
	 <5020DC5F02000078000931C2@nat28.tlf.novell.com>
	 <1344331830.7208.6.camel@mfleming-mobl1.ger.corp.intel.com>
	 <50210F0702000078000932EB@nat28.tlf.novell.com>
	 <1344502295.9195.7.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CAE9FiQUuQAEzin2uXRXWhMXAviu8MXLDkfjFbFJMWB4xkKimFA@mail.gmail.com>
	 <20120810192653.GA11641@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Tue, 21 Aug 2012 15:16:44 +0100
Message-ID: <1345558604.3088.47.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-10 at 20:26 +0100, Matthew Garrett wrote:
> On Fri, Aug 10, 2012 at 12:22:12PM -0700, Yinghai Lu wrote:
> 
> > What is solution for this regression?
> 
> Revert the patch for now, we'll add it back once we've got the UEFI 
> pagetable set up.

FYI I've got a proof of concept patch that seems to work on my ASUS
machine.

I'll try and get it sent out before the end of the week, but failing
that it'll probably be after Plumbers.

