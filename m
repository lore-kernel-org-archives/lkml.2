Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab1BOXEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 18:04:36 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50472 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab1BOXEd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 18:04:33 -0500
MIME-Version: 1.0
In-Reply-To: <20110215135054.GD18248@shisha.kicks-ass.net>
References: <1296701663-12168-1-git-send-email-arve@android.com>
	<1297750276-12475-4-git-send-email-arve@android.com>
	<20110215135054.GD18248@shisha.kicks-ass.net>
Date: Tue, 15 Feb 2011 15:04:31 -0800
Message-ID: <AANLkTim776VyU_LioTL2-pOjskVDeU4BpFuw6CxGUXRT@mail.gmail.com>
Subject: Re: [PATCH 4/8] ARM: etm: Allow range selection
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 5:50 AM, Alexander Shishkin <virtuoso@slind.org> wrote:
> On Mon, Feb 14, 2011 at 10:11:12PM -0800, Arve Hjønnevåg wrote:
>> Trace kernel text segment by default as before, allow tracing of other
>> ranges by writing a range to /sys/devices/etm/trace_range, or to trace
>> everything by writing 0 0.
>
> Since you're adding this, I think it might make sense to add a 3rd optional
> ctx id field, so that userspace tracing is also possible, especially when
> on-chip ETB sizes increase to something more sensible than what they are
> these days.
>

That might be useful, but I think it can be added later. My main
motivation for adding this is so we can turn off the filtering. We
want to use tracing in combination with a hardware watchdog to debug
hard lockups and we don't want any filtering in this case.

-- 
Arve Hjønnevåg
