Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab2IQKuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:50:08 -0400
Received: from relay.parallels.com ([195.214.232.42]:35820 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab2IQKuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:50:06 -0400
Message-ID: <50570052.8050205@parallels.com>
Date: Mon, 17 Sep 2012 14:49:54 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Chuck Lever <chuck.lever@oracle.com>
CC: "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jlayton@redhat.com" <jlayton@redhat.com>
Subject: Re: [PATCH 0/3] lockd: use per-net refrence-counted NSM clients
References: <20120914140811.10835.81465.stgit@localhost.localdomain> <4030B8F9-5C67-4AE7-826E-B4B6AD4FAD01@oracle.com> <4FA345DA4F4AE44899BD2B03EEEC2FA908FA7F55@SACEXCMBX04-PRD.hq.netapp.com> <DA466953-BF79-44F7-8870-AC2FD5E3FEC2@oracle.com>
In-Reply-To: <DA466953-BF79-44F7-8870-AC2FD5E3FEC2@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

14.09.2012 23:10, Chuck Lever пишет:
>
> On Sep 14, 2012, at 1:38 PM, Myklebust, Trond wrote:
>
>> On Fri, 2012-09-14 at 13:01 -0400, Chuck Lever wrote:
>>> What happens if statd is restarted?
>>
>> Nothing unusual. Why?
>
> The NSM upcall transport is a potential application for TCP + softconn, now that a persistent rpc_clnt is used.  It just depends on what failure mode we'd like to optimize for.
>

I don't understand, where the problem is.
Could you be more specific, please?

-- 
Best regards,
Stanislav Kinsbursky
