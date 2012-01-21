Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab2AUFwu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 00:52:50 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40663 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2AUFwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 00:52:47 -0500
MIME-Version: 1.0
In-Reply-To: <20120121025712.GB4656@google.com>
References: <1325654312-32477-1-git-send-email-msb@chromium.org>
	<1325654312-32477-3-git-send-email-msb@chromium.org>
	<20120121000842.GB2908@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120121025712.GB4656@google.com>
Date: Fri, 20 Jan 2012 21:52:45 -0800
X-Google-Sender-Auth: M6rfky2YIno6wZMlUnFeerAJ3-g
Message-ID: <CAOS58YOZEcDrUEaZXBmrys32bnRTPN_n5mZeyYXgVH=-6swz8Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] cgroup: remove extra calls to find_existing_css_set
From: Tejun Heo <tj@kernel.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 20, 2012 at 6:57 PM, Mandeep Singh Baines <msb@chromium.org> wrote:
> If I break out of step 2 via the goto (out_put_css_set_refs), I only
> want to put back the refs I've gotten so far.

But isn't tc->cg NULL if that happens?  (ooh, the if statement should
be testing tc->cg, my bad).

Thanks.

-- 
tejun
