Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab2FKOsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:48:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52643 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab2FKOsL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:48:11 -0400
MIME-Version: 1.0
In-Reply-To: <1339383989.3025.2.camel@lorien2>
References: <20120606070008.GA1494@gmail.com> <1338967142-6249-1-git-send-email-fabio.baltieri@gmail.com>
 <CAK5ve-+gv=83MLAttiq8NYK0d_242UWRjJZftyKHONqMkxWTxQ@mail.gmail.com>
 <20120606111007.GA1311@gmail.com> <CAK5ve-LrnZQqAi2tamFfdN1_upjGQ=TYgpU-xLXnL+8xRv=+Xw@mail.gmail.com>
 <20120606191149.GA1376@gmail.com> <1339014612.2763.98.camel@lorien2>
 <CAK5ve-L7UWAMErdVBLXGtJr7esQJ=0TCQfD+pyDbA+qdBVNuqQ@mail.gmail.com> <1339383989.3025.2.camel@lorien2>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Mon, 11 Jun 2012 22:47:49 +0800
X-Google-Sender-Auth: dkmu2uNJArUoAS3g4nR7QNASvQc
Message-ID: <CAK5ve-Kxs+1DW9ed1epj67U0+UjCiNpdFucu+1YW2HOY+UHv4w@mail.gmail.com>
Subject: Re: [PATCH v2] leds: fix led_brightness_set when soft-blinking
To: shuahkhan@gmail.com
Cc: Fabio Baltieri <fabio.baltieri@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 11:06 AM, Shuah Khan <shuahkhan@gmail.com> wrote:
> On Thu, 2012-06-07 at 20:58 +0800, Bryan Wu wrote:
>
>>
>> Hi Fabio, thanks for updating this. I've added use the v3 replace the
>> old one in my for-next and devel branches
>>
>> Shuah, Thanks for reviewing, if you wanna try this, just grab patches
>> from devel branch.
>>
>
> Bryan,
>
> Did some testing on your devel branch. Did back to back timer and
> oneshot trigger activations and didn't see any problems. Looks good to
> me.
>
Thanks a lot, Shuah,

-Bryan


-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
