Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab1KVObc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:31:32 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58291 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab1KVOba convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:31:30 -0500
MIME-Version: 1.0
In-Reply-To: <CACoXjc=RBpB6eYu1zB-kCcYmsV8rdbzYtdxyBJDLTdt6uu04ig@mail.gmail.com>
References: <1321945877-22802-1-git-send-email-tinamdar@apm.com>
	<CA+5PVA7BD9jNoV9LrXjk2+UPBW8MSTPkwpYPFj2y-CNkXCrAhA@mail.gmail.com>
	<CACoXjc=RBpB6eYu1zB-kCcYmsV8rdbzYtdxyBJDLTdt6uu04ig@mail.gmail.com>
Date: Tue, 22 Nov 2011 09:31:29 -0500
Message-ID: <CA+5PVA6b7Ezo7LsRHX94spkdMabSWGw6q+HJYGsUepY33ArRRw@mail.gmail.com>
Subject: Re: powerpc: dts: Fix canyonlands EMAC interrupt map
From: Josh Boyer <jwboyer@gmail.com>
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 9:15 AM, Tanmay Inamdar <tinamdar@apm.com> wrote:
>
> On Tue, Nov 22, 2011 at 5:00 PM, Josh Boyer <jwboyer@gmail.com> wrote:
>>
>> On Tue, Nov 22, 2011 at 2:11 AM, Tanmay Inamdar <tinamdar@apm.com> wrote:
>> > Fixing interrupt mapping of EMAC for canyonlands
>> >
>> > Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
>>
>> As far as I can tell, your changes aren't really changing anything
>> just making it a bit clearer, correct?  If so, do you mind if I change
>> the commit log to "clear up" instead of fix?
>
> Actually Rob Herring's commit
> (http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=dc9372808412edbc653a675a526c2ee6c0c14a91)
> breaks the interrupt mapping in EMAC driver.
> I am trying to fix this issue by mapping interrupts in different way.

I see.  That should have been in the commit log then.  I'll add
something like that to it.

josh
