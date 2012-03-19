Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543Ab2CSXCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 19:02:48 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41784 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758372Ab2CSXCr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 19:02:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120319154649.0687f545.akpm@linux-foundation.org>
References: <20120316205556.595309230@openvz.org>
	<20120316210343.925446961@openvz.org>
	<20120319151507.93bab32a.akpm@linux-foundation.org>
	<20120319223941.GJ19594@moon>
	<CAFLxGvxEDs=RG7tX+j6XEUx2+wEvuCGipUzh2vSp3rj15Rq6zA@mail.gmail.com>
	<20120319154649.0687f545.akpm@linux-foundation.org>
Date: Tue, 20 Mar 2012 00:02:44 +0100
Message-ID: <CAFLxGvyCRAq6t8_ni+VFUVpOGJ4-iz0i=PRFEFpVJ+ZaPEb3-g@mail.gmail.com>
Subject: Re: [patch 1/2] c/r: prctl: Add ability to set new mm_struct::exe_file
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, LKML <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 11:46 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> Well, let's discuss this more completely.  In what ways could an
> attacker use this?  How serious is the problem?  What actions can be
> taken to lessen it?  etcetera.

After considering the problem a bit more I think it's not a big problem.
We must not trust /proc/pid/exe in anyway.
An attacker can always execute another binary without calling execve().

So, why makes that one-short fashion the feature more secure?
Let the user change the exe symlink as often as he wants.
>From a security point of view the exe symlink is anyway useless.

-- 
Thanks,
//richard
