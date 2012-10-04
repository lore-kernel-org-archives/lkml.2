Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab2JDKB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:01:26 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:34743 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab2JDKBZ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:2>);
	Thu, 4 Oct 2012 06:01:25 -0400
Message-Id: <506D7A93020000780009F98E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 04 Oct 2012 11:01:23 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matt Fleming" <matt.fleming@intel.com>
Cc: <mingo@kernel.org>, <x86@kernel.org>, <mjg@redhat.com>,
        <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86, mm: Include the entire kernel memory map
 in trampoline_pgd
References: <1349269157-25956-1-git-send-email-matt@console-pimps.org>
 <1349269157-25956-2-git-send-email-matt@console-pimps.org>
 <506C4C3A020000780008D041@nat28.tlf.novell.com>
 <1349273028.7223.35.camel@mfleming-mobl1.ger.corp.intel.com>
 <506D4988020000780009F86E@nat28.tlf.novell.com>
 <1349342304.15966.25.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1349342304.15966.25.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.10.12 at 11:18, Matt Fleming <matt.fleming@intel.com> wrote:
> On Thu, 2012-10-04 at 07:32 +0100, Jan Beulich wrote:
>> Btw., once this set of yours is in - will I need to resubmit the
>> time handling patch that actually triggered this work, or will
>> you just reinstate it without further action on my part?
> 
> It's up to you. If you don't want to make any changes to your original
> patch then I'll just re-apply it on top of this series, updating the
> commit log to note why it got reverted and why it's now OK to re-apply.

Afaict no changes should be necessary (so long as the patch
still applies).

Jan

