Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab0H3RzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:55:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39623 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445Ab0H3RzC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:55:02 -0400
MIME-Version: 1.0
In-Reply-To: <838632.57445.qm@web180307.mail.gq1.yahoo.com>
References: <1283154702-23008-1-git-send-email-myungjoo.ham@samsung.com> <838632.57445.qm@web180307.mail.gq1.yahoo.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 30 Aug 2010 11:54:41 -0600
X-Google-Sender-Auth: Ji4XxrSIBaIpyeSVoqDTVA2AWeo
Message-ID: <AANLkTikpRcqPJay-7zjDiZg3w=+gUk3kks=payPazxxj@mail.gmail.com>
Subject: Re: [RFC PATCH] GPIO: add control of powerdown modes and pull-up/down configurations.
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jani Nikula <ext-jani.1.nikula@nokia.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        MyungJoo Ham <myungjoo.ham@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 11:35 AM, David Brownell <david-b@pacbell.net> wrote:
>
>
> --- On Mon, 8/30/10, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
>
>> From: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Subject: [RFC PATCH] GPIO: add control of powerdown modes and pull-up/down configurations.
>
> NAK.

Seconded.  I completely agree with David's comments.

g.

>
> Note that Documentation/gpio.txt specifies such
> pinmux/configuration as out of scope.  There isn't
> even uniformity of models about such things between
> SOCs (and ASICs etc).
>
> Put these kinds of things in arch-specific code,
> which has good reason to know about all the ways
> each platform differs from others, and to cope.
>
> Look at OMAP and AT91 for some examples of SOCs
> which have addressed these issues cleanly, and
> without committing mayhem on the GPIO framework.
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
