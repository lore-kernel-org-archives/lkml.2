Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab1JSE4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 00:56:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41973 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab1JSE4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 00:56:33 -0400
MIME-Version: 1.0
In-Reply-To: <CALdu-PA7+bygEP-44XB8evaTrsZiDopc-24SmUV+0NbiA=sHNw@mail.gmail.com>
References: <1316758874.7393.2.camel@marge.simson.net> <4E7C2E7F.40307@cn.fujitsu.com>
 <1316762345.8168.4.camel@marge.simson.net> <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
 <1316770936.6641.11.camel@marge.simson.net> <1316775204.7562.9.camel@marge.simson.net>
 <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
 <1316788392.6544.33.camel@marge.simson.net> <1318224892.6161.45.camel@marge.simson.net>
 <1318233815.6527.5.camel@marge.simson.net> <1318925436.9641.23.camel@marge.simson.net>
 <1318927355.21167.3.camel@twins> <1318927629.9641.27.camel@marge.simson.net>
 <1318928763.21167.5.camel@twins> <1318929825.9641.32.camel@marge.simson.net>
 <1318932693.6748.5.camel@marge.simson.net> <alpine.DEB.2.00.1110181336150.2639@chino.kir.corp.google.com>
 <1318996839.6222.20.camel@marge.simson.net> <CALdu-PA7+bygEP-44XB8evaTrsZiDopc-24SmUV+0NbiA=sHNw@mail.gmail.com>
From: Paul Menage <paul@paulmenage.org>
Date: Tue, 18 Oct 2011 21:56:13 -0700
X-Google-Sender-Auth: BbROHPHfyfcF2c5nq-mSYPaBEOc
Message-ID: <CALdu-PDP5ytAk_W+yUZ4dkJLW_z=sy1jgds2V=4GHykepM_Ufg@mail.gmail.com>
Subject: Re: patch] cpusets, cgroups: disallow attaching kthreadd
To: Mike Galbraith <efault@gmx.de>
Cc: David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 9:53 PM, Paul Menage <paul@paulmenage.org> wrote:
>
> I can see the argument that the number of use-cases for this is fairly
> small, but in line with the principle of keeping the ABI as stable as
> possible in the absence of bugs that force a change, having the
> restriction in the necessary subsystems seems cleaner.
>

Separately, an alternative fix for the cpusets case be to make it
always possible to move a thread to the root cpuset, even if it's
PF_THREAD_BOUND?

Paul
