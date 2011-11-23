Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629Ab1KWB6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 20:58:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63930 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759551Ab1KWB6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 20:58:30 -0500
Message-ID: <4ECC53B4.5060406@cn.fujitsu.com>
Date: Wed, 23 Nov 2011 10:00:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        Tomasz Buchert <tomasz.buchert@inria.fr>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] cgroup_freezer: fix freezing groups with stopped tasks
References: <1321480234-29241-1-git-send-email-mhocko@suse.cz> <20111121230709.GR25776@google.com> <4ECB06D2.6060106@cn.fujitsu.com> <20111122022118.GT25776@google.com> <20111122090522.GA26768@tiehlicka.suse.cz> <20111122153948.GE322@google.com> <20111122154748.GF322@google.com>
In-Reply-To: <20111122154748.GF322@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-23 09:58:10,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-23 09:58:11,
	Serialize complete at 2011-11-23 09:58:11
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> On Tue, Nov 22, 2011 at 07:39:48AM -0800, Tejun Heo wrote:
>>> Signed-off-by: Michal Hocko <mhocko@suse.cz>
>>> Cc: Tomasz Buchert <tomasz.buchert@inria.fr>
>>> Cc: Paul Menage <paul@paulmenage.org>
>>> Cc: Li Zefan <lizf@cn.fujitsu.com>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: Tejun Heo <htejun@gmail.com>
>>
>> Applying to cgroup/for-3.2-fixes.
> 
> I'll apply the original version in cgroup/for-3.2-fixes and deal with
> conflict once pm-freezer branch is merged.  Li, can you please ack
> this?
> 

Sure.

Acked-by: Li Zefan <lizf@cn.fujitsu.com>
