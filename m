Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921Ab2EONfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:35:52 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:60252 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758872Ab2EONfu convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Tue, 15 May 2012 09:35:50 -0400
Message-Id: <4FB277F20200007800083D5B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 15 May 2012 14:36:18 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Cc: <dannf@dannf.org>, <mingo@elte.hu>, <tglx@linutronix.de>,
        <matt.fleming@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH, resend] x86: enable rtc-efi
References: <4FB263560200007800083CB0@nat28.tlf.novell.com>
 <20120515123811.GA25248@srcf.ucam.org>
 <4FB271860200007800083D21@nat28.tlf.novell.com>
 <20120515131637.GA26038@srcf.ucam.org>
 <4FB274CD0200007800083D41@nat28.tlf.novell.com>
 <20120515132631.GA26298@srcf.ucam.org>
In-Reply-To: <20120515132631.GA26298@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 15.05.12 at 15:26, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, May 15, 2012 at 02:22:53PM +0100, Jan Beulich wrote:
> 
>> I don't think so - the two drivers could end up manipulating the
>> same piece of hardware, without synchronization. rtc-cmos
>> really should bail when loaded on an EFI-enabled system.
> 
> That's why we're taking the rtc lock.

Which is completely bogus imo (i.e. it should be a goal to remove
this).

Jan

