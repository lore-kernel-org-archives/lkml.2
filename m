Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab2BOCcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 21:32:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41222 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab2BOCcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 21:32:14 -0500
MIME-Version: 1.0
In-Reply-To: <1329227537.2293.1.camel@twins>
References: <1328560933-3037-1-git-send-email-venki@google.com>
	<1328901567.25989.51.camel@laptop>
	<CABeCy1aUj9MM8YabvvQCYYFm4FNMsomU3PZ1ZyoKikL9hnc9uQ@mail.gmail.com>
	<20120213053410.GB24636@zhy>
	<1329227537.2293.1.camel@twins>
Date: Tue, 14 Feb 2012 18:32:13 -0800
Message-ID: <CABeCy1aC3-nFZBOPufsqqAPki7s-yfDw3m5uMCoCkTNQiE3k0w@mail.gmail.com>
Subject: Re: [RFC] Extend mwait idle to optimize away IPIs when possible
From: Venki Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 5:52 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2012-02-13 at 13:34 +0800, Yong Zhang wrote:
>> Yeah, most of the things could be shared. Such as the added logic when
>> return from idle and the hooks into ttwu_queue_remote() and
>> generic_exec_single().
>>
>
> The thing is, those last two should not have hooks. Nor am I convinced
> anything outside of the arch idle loop should have any.
>

OK. Will put stuff in arch and respin soon..

-Venki
