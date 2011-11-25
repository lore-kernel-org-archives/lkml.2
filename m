Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab1KYCDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 21:03:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53137 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755308Ab1KYCD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 21:03:29 -0500
Message-ID: <4ECEF7DD.6010403@cn.fujitsu.com>
Date: Fri, 25 Nov 2011 10:05:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        paul@paulmenage.org, daniel.lezcano@free.fr, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, fweisbec@gmail.com,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH v2 14/14] Change CPUACCT to default n
References: <1320182360-20043-1-git-send-email-glommer@parallels.com> <1320182360-20043-15-git-send-email-glommer@parallels.com> <4EBD94A0.9070703@google.com> <4EBE4A80.6090607@parallels.com> <CAPM31RLUDpaxDAw00erwgmNogbuD+=LgkJ-5i9ncJw00nvryfQ@mail.gmail.com>
In-Reply-To: <CAPM31RLUDpaxDAw00erwgmNogbuD+=LgkJ-5i9ncJw00nvryfQ@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-25 10:03:05,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-25 10:03:08,
	Serialize complete at 2011-11-25 10:03:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> despite it being a not entirely natural fit.  Something I proposed at
> Prague and that we could explore here is the idea of a co-mounted
> controller.  In this example it would only be mountable with cpu so
> you could always depend on the cpu hierarchy being there; likewise we
> can put (jump-labeled) touchpoints within the cpu-subsystem to call
> out for updates as appropriate when the co-mount exists.
> 

IIUC, this co-mounting idea is something I implemented years ago:

https://lkml.org/lkml/2008/6/18/389

The use case and the reason it was rejected:

https://lkml.org/lkml/2008/7/1/97

--
Li Zefan
