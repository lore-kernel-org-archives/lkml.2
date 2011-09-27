Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1I0KGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 06:06:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64128 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1I0KGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 06:06:06 -0400
MIME-Version: 1.0
In-Reply-To: <4E7DECA0.5020707@parallels.com>
References: <1316393805-3005-1-git-send-email-glommer@parallels.com>
	<1316393805-3005-2-git-send-email-glommer@parallels.com>
	<4E794AA2.9080008@parallels.com>
	<CAKTCnzmkuL+9ftD5d0Z8b5w+DUSUoLiWqSX_TgGxtRxtoPsxpA@mail.gmail.com>
	<4E7DECA0.5020707@parallels.com>
Date: Tue, 27 Sep 2011 15:36:04 +0530
Message-ID: <CAKTCnz=DFUc=s9LzxPp-P2jOPXvNzWj8OswadCR09nVmM=ozxQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] Basic kernel memory functionality for the Memory Controller
From: Balbir Singh <bsingharora@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, gthelen@google.com, netdev@vger.kernel.org,
        linux-mm@kvack.org, kirill@shutemov.name,
        Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I know we have a lot of pending xxx_from_cont() and struct cgroup
>> *cont, can we move it to memcg notation to be more consistent with our
>> usage. There is a patch to convert old usage
>>
>
> Hello Balbir, I missed this comment. What exactly do you propose in this
> patch, since I have to assume that the patch you talk about is not applied?
> Is it just a change to the parameter name that you propose?
>

Yes, it is a patch posted on linux-mm by raghavendra

Balbir Singh
