Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525Ab2GFLQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:16:51 -0400
Received: from thoth.sbs.de ([192.35.17.2]:20820 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757019Ab2GFLQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:16:49 -0400
Message-ID: <4FF6C913.5080808@siemens.com>
Date: Fri, 06 Jul 2012 13:16:35 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 2/7 v6] update linux headers
References: <4FF6B188.2060607@cn.fujitsu.com> <4FF6B232.4050502@cn.fujitsu.com> <4FF6BD1D.8020605@siemens.com> <4FF6C2E2.5020608@cn.fujitsu.com>
In-Reply-To: <4FF6C2E2.5020608@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-06 12:50, Wen Congyang wrote:
> At 07/06/2012 06:25 PM, Jan Kiszka Wrote:
>> On 2012-07-06 11:38, Wen Congyang wrote:
>>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>>
>> Which kvm.git hash is this referring? Please state this to avoid that we
>> are merging support for kernel features that are still under review.
> 
> The following kvm.git:
> http://git.kernel.org/?p=virt/kvm/kvm.git;a=summary
> 
> I apply my kvm's patch, and use ./scripts/update-linux-headers.sh to
> generate this patch.

OK, means the feature is not yet upstream. So this series is for
reference and early review until the kernel interface is accepted. I
personally push my kernel bits first before suggesting the userspace
parts. Avoids duplicate work if the former changes again during review.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
Corporate Competence Center Embedded Linux


