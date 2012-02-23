Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab2BWVSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 16:18:25 -0500
Received: from na3sys010aog104.obsmtp.com ([74.125.245.76]:47175 "HELO
	na3sys010aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753500Ab2BWVSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 16:18:24 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of roland@purestorage.com designates 10.180.78.130 as permitted sender) smtp.mail=roland@purestorage.com; dkim=pass header.i=roland@purestorage.com
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1202231247550.1803@asgard.lang.hm>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
 <4F4661D6.7030809@gmail.com> <CAG4AFWa3cs-V+wfL8o6PauTAOtvj8t1E_iSN5r0A8z=Aqzg0tg@mail.gmail.com>
 <alpine.DEB.2.02.1202231247550.1803@asgard.lang.hm>
From: Roland Dreier <roland@kernel.org>
Date: Thu, 23 Feb 2012 13:18:01 -0800
X-Google-Sender-Auth: 5k6V_sthMrQ9e47gj5hHXarm36g
Message-ID: <CAL1RGDWX2A16aFZEoyegF46powW4JJp1+JJm+_Nv15ikrtQCSQ@mail.gmail.com>
Subject: Re: Can we move device drivers into user-space?
To: david@lang.hm
Cc: Jidong Xiao <jidong.xiao@gmail.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 12:48 PM,  <david@lang.hm> wrote:
> Why would you want to? What advantage are you looking to gain from all the
> effort?

If someone has a paragraph that starts "Advantage:" in their email, that
is usually a good place to look for what they think the advantage of their
idea is.
