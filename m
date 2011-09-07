Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1IGBdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 21:33:08 -0400
Received: from mx2.parallels.com ([64.131.90.16]:45111 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346Ab1IGBdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 21:33:05 -0400
Message-ID: <4E66C9A6.8080804@parallels.com>
Date: Tue, 6 Sep 2011 22:32:22 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Paul Menage <paul@paulmenage.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <containers@lists.osdl.org>, <netdev@vger.kernel.org>,
        <xemul@parallels.com>, "David S. Miller" <davem@davemloft.net>,
        Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] per-cgroup tcp buffer limitation
References: <1315276556-10970-1-git-send-email-glommer@parallels.com> <CALdu-PDoPPdcX0bAkVpaP9R-z1yKin=JOjjT3rMuoSHJaywSCg@mail.gmail.com> <4E66C45A.8060706@parallels.com> <CALdu-PDZC3FTuR31d5+P+=U=0UFVUZD_KDEgPHBeD-MyQ4PuSQ@mail.gmail.com>
In-Reply-To: <CALdu-PDZC3FTuR31d5+P+=U=0UFVUZD_KDEgPHBeD-MyQ4PuSQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.132.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2011 10:29 PM, Paul Menage wrote:
> On Tue, Sep 6, 2011 at 6:09 PM, Glauber Costa<glommer@parallels.com>  wrote:
>>
>> Can you be more specific?
>
> Maybe if you include the source to kmem_cgroup.c :-)
Yeah, *facepalm*.

I am about to send another version, just finishing writing up the docs.
But it is really simple right now, and only cares about the socket 
stuff. No reporting, nothing else. My idea is we use it as a seed and 
grow it.
