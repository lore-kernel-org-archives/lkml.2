Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750788Ab2JHGnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 02:43:46 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:37163 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab2JHGnp convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:2>);
	Mon, 8 Oct 2012 02:43:45 -0400
Message-Id: <5072842D020000780008D495@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 08 Oct 2012 07:43:41 +0100
From: "Jan Beulich" <jbeulich@suse.com>
To: <hpa@zytor.com>
Cc: <matt@console-pimps.org>, <matt.fleming@intel.com>, <mingo@kernel.org>,
        <x86@kernel.org>, <mjg@redhat.com>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86, mm: Include the entire kernel memory map
 in trampoline_pgd
References: <1349269157-25956-1-git-send-email-matt@console-pimps.org>
 <1349269157-25956-2-git-send-email-matt@console-pimps.org>
 <506C4C3A020000780008D041@nat28.tlf.novell.com>
 <506DFAD8.5060701@zytor.com>
 <506E9CDC020000780009FD13@nat28.tlf.novell.com>
 <506F0A90.7020106@zytor.com>
 <50714881020000780008D43E@nat28.tlf.novell.com>
 <e0004a11-4caa-4100-8876-1e7346f50673@email.android.com>
In-Reply-To: <e0004a11-4caa-4100-8876-1e7346f50673@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "H. Peter Anvin" <hpa@zytor.com> 10/07/12 12:27 PM >>>
>Actually, no, because we may need to double-map in the low address space per discussion at LPC.

Now this I don't follow (due to lack of context), but it would of course be
relevant for determining the need eventual further adjustments to the patch
we're discussing here.

Jan

>Jan Beulich <jbeulich@suse.com> wrote:
>
>>>On 10/04/2012 11:39 PM, Jan Beulich wrote:
>>I understand all that, but here we're talking about a true 1:1 mapping
>>(i.e. in the lower half of the virtual address space), as opposed to
>>the
>>direct mapping (in the upper half). We can obviously use all of the
>>lower
>>half for this purpose.


