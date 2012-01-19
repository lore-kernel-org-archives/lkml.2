Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab2ASMa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 07:30:28 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49381 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2ASMaY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 07:30:24 -0500
MIME-Version: 1.0
In-Reply-To: <4F17C5A6.50501@cn.fujitsu.com>
References: <4F177C67.6070907@cn.fujitsu.com>
	<20120119022401.GH21533@google.com>
	<4F17C5A6.50501@cn.fujitsu.com>
Date: Thu, 19 Jan 2012 04:30:23 -0800
X-Google-Sender-Auth: A_0POr67kKF0dhqb9R0vtomNqsE
Message-ID: <CAOS58YMAQ0siUa=j8KsdWiAM3rqtZTvbOvmGc3L3cU0zwpuHPQ@mail.gmail.com>
Subject: Re: [RFC] splitting cgroup.c
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Wed, Jan 18, 2012 at 11:26 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> I agree that splitting is necessary but IMHO splitting usually tends
>> to go too far.  Maybe we can split it into two and think about further
>> splitting later on?  e.g. internal logic vs. userland interfacing.
>
> This isn't feasible. The feasible way is to split by functionality,
> which I think was the way taken by perf developers.

Eh? Feasible or desirable?  How can it be not feasible?  Why?

Thanks.

-- 
tejun
