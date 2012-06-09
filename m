Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab2FIT2o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 15:28:44 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:33191 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab2FIT2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 15:28:42 -0400
MIME-Version: 1.0
In-Reply-To: <1339232401-14392-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1339232401-14392-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Sat, 9 Jun 2012 15:28:21 -0400
Message-ID: <CAHGf_=oPLXvgPzeAn0Cn5Pni0NrdOzZ=hNTmAg5QACCzuv7z9A@mail.gmail.com>
Subject: Re: [PATCH -V8 02/16] hugetlb: don't use ERR_PTR with VM_FAULT* values
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 9, 2012 at 4:59 AM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>
> The current use of VM_FAULT_* codes with ERR_PTR requires us to ensure
> VM_FAULT_* values will not exceed MAX_ERRNO value. Decouple the
> VM_FAULT_* values from MAX_ERRNO.
>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

I like this much.

 Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
