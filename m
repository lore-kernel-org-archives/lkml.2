Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965192Ab2CSXXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 19:23:09 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62975 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab2CSXXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 19:23:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120319231709.GM19594@moon>
References: <20120316205556.595309230@openvz.org>
	<20120316210343.925446961@openvz.org>
	<20120319151507.93bab32a.akpm@linux-foundation.org>
	<20120319223941.GJ19594@moon>
	<CAFLxGvxEDs=RG7tX+j6XEUx2+wEvuCGipUzh2vSp3rj15Rq6zA@mail.gmail.com>
	<20120319154649.0687f545.akpm@linux-foundation.org>
	<CAFLxGvyCRAq6t8_ni+VFUVpOGJ4-iz0i=PRFEFpVJ+ZaPEb3-g@mail.gmail.com>
	<20120319231709.GM19594@moon>
Date: Tue, 20 Mar 2012 00:23:06 +0100
Message-ID: <CAFLxGvwu_T04CYsUd33ZxuumvJ9hBHD+fGzS-ubS831jV8wqyg@mail.gmail.com>
Subject: Re: [patch 1/2] c/r: prctl: Add ability to set new mm_struct::exe_file
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 12:17 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
>> So, why makes that one-short fashion the feature more secure?
>> Let the user change the exe symlink as often as he wants.
>> From a security point of view the exe symlink is anyway useless.
>
> Maybe better to call it 'predictable' then rather than 'secure'?

I'd say one-short makes it less confusing. :-)

-- 
Thanks,
//richard
