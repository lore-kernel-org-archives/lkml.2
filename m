Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab2CLKbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 06:31:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059Ab2CLKbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 06:31:49 -0400
Message-ID: <4F5DD084.3050200@redhat.com>
Date: Mon, 12 Mar 2012 12:31:32 +0200
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
References: <4F58664D.1070800@cn.fujitsu.com> <4F58943E.1050402@redhat.com> <4F595B31.9090301@cn.fujitsu.com>
In-Reply-To: <4F595B31.9090301@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2012 03:21 AM, Wen Congyang wrote:
> >>
> >> Changes from v2 to v3:
> >> 1. correct spelling
> >>
> >> Changes from v1 to v2:
> >> 1. split up host and guest-side changes
> >> 2. introduce new request flag to avoid changing return values.
> > 
> > I see no Documentation/ changes.
>
> What shoude be writen into Documentation/? I read the documents under
> Documentation/virtual/kvm, not all KVM_EXIT_* are writen in api.txt.
> In this patch set, I introduce a new exit_reason: KVM_EXIT_GUEST_PANICKED,
> but I donot know where I should write.

Describe the exit (why it happens).  Also document the new hypercall. 
If there is no good place for it, start a new file.

-- 
error compiling committee.c: too many arguments to function

