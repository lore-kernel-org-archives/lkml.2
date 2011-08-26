Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab1HZO4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:56:33 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38964 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab1HZO4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:56:30 -0400
MIME-Version: 1.0
In-Reply-To: <20110826140900.GF2632@htj.dyndns.org>
References: <1314312192-26885-1-git-send-email-tj@kernel.org>
 <4E5753D3.9080500@cn.fujitsu.com> <20110826140900.GF2632@htj.dyndns.org>
From: Paul Menage <paul@paulmenage.org>
Date: Fri, 26 Aug 2011 07:56:09 -0700
X-Google-Sender-Auth: f7z_6JHDGsNLW2iLOxel_IHhN5U
Message-ID: <CALdu-PBthm1AcRX1UOAQEpXVWMU60UEPjMEcLDig3vZOawT9-A@mail.gmail.com>
Subject: Re: [PATCHSET] cgroup: introduce cgroup_taskset and consolidate
 subsys methods, take#2
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, rjw@sisk.pl,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 7:09 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Fri, Aug 26, 2011 at 04:05:39PM +0800, Li Zefan wrote:
>> It's fine for me to route those patches through pm-freezer, since this
>> work is initiated and needed for the work on freezer.
>
> Awesome.  Paul, what do you think?  Rafael, if Paul agrees, can you
> please take in this series?
>

Sure - but can you make sure that there's nothing in -mm that
conflicts with this patchset? If there is, then maybe cherry-pick
those into pm-freezer too, and fix them up?

Paul
