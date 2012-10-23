Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104Ab2JWNxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:53:20 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42690 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978Ab2JWNxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:53:18 -0400
Message-ID: <5086A14A.7000400@suse.cz>
Date: Tue, 23 Oct 2012 15:53:14 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Aristeu Rozanski <aris@redhat.com>
CC: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, James Morris <jmorris@namei.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>, cgroups@vger.kernel.org
Subject: Re: [PATCH 1/4] cgroup: fix invalid rcu dereference
References: <20121022134536.172969567@napanee.usersys.redhat.com> <20121022134536.543579196@napanee.usersys.redhat.com> <508692A8.6090706@suse.cz> <20121023131746.GB14085@redhat.com>
In-Reply-To: <20121023131746.GB14085@redhat.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 03:17 PM, Aristeu Rozanski wrote:
> On Tue, Oct 23, 2012 at 02:50:48PM +0200, Jiri Slaby wrote:
>> No, I'm *not* the author of the patch... Or at least I don't remember
>> :P. Where did you take it from?
> 
> <1347615612-11450-1-git-send-email-jslaby@suse.cz> 
> Date: Fri, 14 Sep 2012 11:40:12 +0200
> 
> you didn't include a "From:" on your email, so I assumed it was from
> you. it was sent to akpm with others and linux-kernel in cc

Ah, ok, you convinced me that I'm the author of the patch :).


-- 
js
suse labs
