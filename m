Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab2I1Bp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 21:45:27 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34652 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab2I1Bp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 21:45:26 -0400
MIME-Version: 1.0
In-Reply-To: <5064FDCA.1020504@jp.fujitsu.com>
References: <1348724705-23779-1-git-send-email-wency@cn.fujitsu.com>
 <1348724705-23779-3-git-send-email-wency@cn.fujitsu.com> <CAHGf_=rLMsmAxR5hrDVXjkHAxmupVrmtqE3iq2qu=O9Prp4nSg@mail.gmail.com>
 <5064EA5A.3080905@jp.fujitsu.com> <CAHGf_=qbBGjTL9oBHz7AM8BAosbzvn_WAGdAzJ8np-nDPN_KFQ@mail.gmail.com>
 <5064FDCA.1020504@jp.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 27 Sep 2012 21:37:50 -0400
X-Google-Sender-Auth: Vpj3IBNLvMqv-Z7ci-ubSUPvuzs
Message-ID: <CAHGf_=r+oz0GS137e81EySbN-3KVmQisF8sySiCUYUas1RZLtQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] memory-hotplug: add node_device_release
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: wency@cn.fujitsu.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, minchan.kim@gmail.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Moreover, your explanation is still insufficient. Even if
>> node_device_release() is empty function, we can get rid of the
>> warning.
>
>
> I don't understand it. How can we get rid of the warning?

See cpu_device_release() for example.



>> Why do we need this node_device_release() implementation?
>
> I think that this is a manner of releasing object related kobject.

No.  Usually we never call memset() from release callback.
