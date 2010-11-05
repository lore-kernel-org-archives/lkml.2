Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab0KEFzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 01:55:43 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47099 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab0KEFzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 01:55:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=erG9uV+3A2vHVRM3G4GhLaL3Y7EUWo3+BR04GiGuYAZApD2E3lVD4phQdkM5qGr2g4
         Q/HJvtNwLtoNGw6BvHMU80ndDjdUfP1wsOtU88Rhpr3iW20/KfepIa4EJ/JyZ4NLfi3l
         yrCoaROUK9Vw++aRYSfYVzp5WGe4Z01Pnl2os=
MIME-Version: 1.0
In-Reply-To: <AANLkTikL4Ng0mJmeO0p_gtZWticd6NO3b9daHcRX4q1Q@mail.gmail.com>
References: <AANLkTikL4Ng0mJmeO0p_gtZWticd6NO3b9daHcRX4q1Q@mail.gmail.com>
Date: Fri, 5 Nov 2010 13:55:40 +0800
Message-ID: <AANLkTiknaHiWUzOH+MjAujk_+0JfX2x2auRCgFjUqhU-@mail.gmail.com>
Subject: Re: mmotm 2010-11-03-12-17: memcg build fail
From: Dave Young <hidave.darkstar@gmail.com>
To: Greg Thelen <gthelen@google.com>, Andrea Righi <arighi@develer.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot cc lkml

On Fri, Nov 5, 2010 at 1:54 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> Hi,
>
> Build failed without __divdi3 on i386, known issue?
>
> mm/built-in.o: In function `mem_cgroup_dirty_info':
> /home/dave/vdb/build/mm/linux-2.6.36/mm/memcontrol.c:1251: undefined
> reference to `__divdi3'
> /home/dave/vdb/build/mm/linux-2.6.36/mm/memcontrol.c:1259: undefined
> reference to `__divdi3'
> make: *** [.tmp_vmlinux1] Error 1
>
> --
> Regards
> dave
>



-- 
Regards
dave
