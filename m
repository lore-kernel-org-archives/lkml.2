Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211Ab2EPHvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:51:52 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:34860 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713Ab2EPHvv convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 16 May 2012 03:51:51 -0400
Message-Id: <4FB378D10200007800084003@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 16 May 2012 08:52:17 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matt Domsch" <Matt_Domsch@dell.com>, "Mike Waychison" <mikew@google.com>
Cc: "matt.fleming@linux.intel.com" <matt.fleming@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, resend] efivars: remove stray exports
References: <4FB262940200007800083CAC@nat28.tlf.novell.com>
 <20120515125542.GA14357@emperor.us.dell.com>
 <CAGTjWtB-aD+yajy6UaQ=zh2RNydCmdPF6GMr6_24xkVmAsFzwA@mail.gmail.com>
 <CAGTjWtCZqfaxQDB6pCp_twh5fJFJ86Ez3mbxQ8avCzoiywK5mA@mail.gmail.com>
In-Reply-To: <CAGTjWtCZqfaxQDB6pCp_twh5fJFJ86Ez3mbxQ8avCzoiywK5mA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 15.05.12 at 19:02, Mike Waychison <mikew@google.com> wrote:
> On Tue, May 15, 2012 at 10:01 AM, Mike Waychison <mikew@google.com> wrote:
>> On Tue, May 15, 2012 at 5:55 AM, Matt Domsch <Matt_Domsch@dell.com> wrote:
>>> On Tue, May 15, 2012 at 07:05:08AM -0500, Jan Beulich wrote:
>>>> There's no in-tree consumer, and the way they are currently prototyped
>>>> it doesn't look like they're really usable from anywhere but the base
>>>> EFI implementation.
>>>
>>> Seems reasonable, copying Mike who created the code paths being
>>> modified here.
>>
>> I'm using these in drivers/google/firmware/gsmi.c
>>
> 
> drivers/firmware/google/gsmi.c even (sorry, just starting my day...)

Oh - should have re-checked before re-sending (this must have
appeared after the original posting).

Jan

