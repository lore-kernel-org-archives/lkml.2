Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab1IGBaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 21:30:19 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56556 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab1IGBaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 21:30:16 -0400
MIME-Version: 1.0
In-Reply-To: <4E66C45A.8060706@parallels.com>
References: <1315276556-10970-1-git-send-email-glommer@parallels.com>
 <CALdu-PDoPPdcX0bAkVpaP9R-z1yKin=JOjjT3rMuoSHJaywSCg@mail.gmail.com> <4E66C45A.8060706@parallels.com>
From: Paul Menage <paul@paulmenage.org>
Date: Tue, 6 Sep 2011 18:29:55 -0700
X-Google-Sender-Auth: YCI0X6SAzodbmD2f0lmHxfq32qU
Message-ID: <CALdu-PDZC3FTuR31d5+P+=U=0UFVUZD_KDEgPHBeD-MyQ4PuSQ@mail.gmail.com>
Subject: Re: [PATCH] per-cgroup tcp buffer limitation
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, netdev@vger.kernel.org, xemul@parallels.com,
        "David S. Miller" <davem@davemloft.net>,
        Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 6, 2011 at 6:09 PM, Glauber Costa <glommer@parallels.com> wrote:
>
> Can you be more specific?

Maybe if you include the source to kmem_cgroup.c :-)

Things like the reporting of stats to user space, configuring limits,
etc, ought to be common with the other kernel memory tracking. (Sadly,
I've lost track of the status of the other kernel memory effort -
Kamezawa or the OpenVZ folks probably have a better handle on that).

Paul
