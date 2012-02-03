Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab2BCVQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 16:16:51 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64264 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab2BCVQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 16:16:49 -0500
MIME-Version: 1.0
In-Reply-To: <87d39vajq4.fsf@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
 <20120202194258.GU15343@ponder.secretlab.ca> <87d39vajq4.fsf@ti.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 3 Feb 2012 14:16:29 -0700
X-Google-Sender-Auth: hLfGZ7QKQbiWdCXYCJyCpQ5fFIU
Message-ID: <CACxGe6uLR2ou7+TQdHubrEuHtonbgVtO1ow3iQV5V-jVSx=LWA@mail.gmail.com>
Subject: Re: [PATCH v9 00/25] gpio/omap: driver cleanup and fixes
To: Kevin Hilman <khilman@ti.com>
Cc: Tarun Kanti DebBarma <tarun.kanti@ti.com>, linux-omap@vger.kernel.org,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 10:51 AM, Kevin Hilman <khilman@ti.com> wrote:
> Grant Likely <grant.likely@secretlab.ca> writes:
>
>> On Thu, Feb 02, 2012 at 11:00:26PM +0530, Tarun Kanti DebBarma wrote:
>>> The following changes since commit 62aa2b537c6f5957afd98e29f96897419ed5ebab:
>>>   Linus Torvalds (1):
>>>         Linux 3.3-rc2
>>>
>>> are available in the git repository at:
>>> http://gitorious.org/~tarunkanti/omap-sw-develoment/tarunkantis-linux-omap-dev
>>> Branch: for_3.4/gpio_cleanup_fixes_v9
>>
>> Bad git url.  I had to replace 'http:' with 'git:'.
>>
>> I've merged this series into my gpio/next branch.  It should show up in
>> linux-next in a couple of days.
>
> Grant, this series isn't quite ready for merge, and shouldn't be
> considered a pull request.

No problem.  I'll drop it from my tree.

g.
