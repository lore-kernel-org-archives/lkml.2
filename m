Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab2CHLNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 06:13:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab2CHLNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 06:13:16 -0500
Message-ID: <4F58943E.1050402@redhat.com>
Date: Thu, 08 Mar 2012 13:13:02 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F58664D.1070800@cn.fujitsu.com>
In-Reply-To: <4F58664D.1070800@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2012 09:57 AM, Wen Congyang wrote:
> We can know the guest is paniced when the guest runs on xen.
> But we do not have such feature on kvm.
>
> Another purpose of this feature is: management app(for example:
> libvirt) can do auto dump when the guest is crashed. If management
> app does not do auto dump, the guest's user can do dump by hand if
> he sees the guest is paniced.
>
> I touch the hypervisor instead of using virtio-serial, because
> 1. it is simple
> 2. the virtio-serial is an optional device, and the guest may
>    not have such device.
>
> Changes from v2 to v3:
> 1. correct spelling
>
> Changes from v1 to v2:
> 1. split up host and guest-side changes
> 2. introduce new request flag to avoid changing return values.

I see no Documentation/ changes.

-- 
error compiling committee.c: too many arguments to function

