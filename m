Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab0HDBzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 21:55:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53524 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758008Ab0HDBzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 21:55:53 -0400
Message-ID: <4C58C9C9.3040008@cn.fujitsu.com>
Date: Wed, 04 Aug 2010 10:00:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, ebiederm@xmission.com,
        matthltc@us.ibm.com, menage@google.com, oleg@redhat.com
Subject: Re: [PATCH v4 0/2] cgroups: implement moving a threadgroup's threads
 atomically with cgroup.procs
References: <20100730235649.GA22644@ghc17.ghc.andrew.cmu.edu> <20100803125827.0822e6ab.akpm@linux-foundation.org>
In-Reply-To: <20100803125827.0822e6ab.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 30 Jul 2010 19:56:49 -0400
> Ben Blum <bblum@andrew.cmu.edu> wrote:
> 
>> This patch series implements a write function for the 'cgroup.procs'
>> per-cgroup file, which enables atomic movement of multithreaded
>> applications between cgroups. Writing the thread-ID of any thread in a
>> threadgroup to a cgroup's procs file causes all threads in the group to
>> be moved to that cgroup safely with respect to threads forking/exiting.
>> (Possible usage scenario: If running a multithreaded build system that
>> sucks up system resources, this lets you restrict it all at once into a
>> new cgroup to keep it under control.)
> 
> I can see how that would be useful.  No comments from anyone else?
> 

Oleg had been commenting on this patchset, so it would be nice to know
if he's comfortable with the changes in this version.

