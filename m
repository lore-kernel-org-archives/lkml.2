Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab2EYPAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:00:07 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:57412 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab2EYPAF convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 25 May 2012 11:00:05 -0400
Message-Id: <4FBFBAB5020000780008635F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 25 May 2012 16:00:37 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <matt.fleming@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: use EFI to deal with platform wall clock
References: <4FB265AB0200007800083CC5@nat28.tlf.novell.com>
 <20120515124707.GB25248@srcf.ucam.org>
 <4FB273EB0200007800083D32@nat28.tlf.novell.com>
 <20120515132006.GA26196@srcf.ucam.org>
 <4FB3B734020000780008415D@nat28.tlf.novell.com>
 <20120516123912.GA20990@srcf.ucam.org>
In-Reply-To: <20120516123912.GA20990@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 16.05.12 at 14:39, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, May 16, 2012 at 01:18:28PM +0100, Jan Beulich wrote:
>> So I'm afraid if the patch as I provided it isn't acceptable, and
>> if the call to efi_enter_virtual_mode() can't be moved ahead
>> of the one to timekeeping_init(), this winds down to the whole
>> logic needing a re-write.
> 
> I have zero objection to this being cleaned up, but I don't know of any 
> obvious reason why we can't do enter_virtual_mode() earlier.

So this indeed works (moving enter_virual_mode() invocation
to the end of mm_init(), which seems to most logical place to
me) on the single system I can try this out on. I'll submit an
updated patch soon.

Jan

