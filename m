Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507Ab1D0QBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:01:45 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:40895 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759430Ab1D0QBn convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Wed, 27 Apr 2011 12:01:43 -0400
Message-Id: <4DB85A4F020000780003E6F7@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 27 Apr 2011 17:02:55 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: re-use kernel/syscall_table_32.S in
	 ia32/ia32entry.S
References: <4DB85376020000780003E6C9@vpn.id2.novell.com>
 <4DB83946.609@zytor.com>
In-Reply-To: <4DB83946.609@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 27.04.11 at 17:41, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 04/27/2011 08:33 AM, Jan Beulich wrote:
>> This requires a little bit of renaming, and a (much shorter than the
>> original full table) set of #define-s for those table entries where
>> native and compat mode entries differ.
>> 
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> Hm... not 100% sure I think this is an improvement, partly because it
> creates "action at a distance" -- you now have to look in two separate
> places to find out what actually happens with a system call -- and
> because the i386 table is already a bit of an "odd man out".  I would
> much rather like to see a setup where you have __SYSCALL() macros in
> unistd_64.h-style and perhaps augment it with a 3-operand __SYSCALL()
> macro for the case where compat and non-compat are different.
> 
> What do you think?

Yes, that's certainly an alternative.

Jan

