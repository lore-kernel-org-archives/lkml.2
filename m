Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab2EFMAa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 08:00:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372Ab2EFMA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 08:00:29 -0400
Message-ID: <4FA667D7.4040201@redhat.com>
Date: Sun, 06 May 2012 15:00:23 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Sasha Levin <levinsasha928@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: async pf: INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected
References: <CA+1xoqcPSCA+iNdMETZMhXpmGaVkC2ACCJZAt4CSBkaoVwVvGQ@mail.gmail.com> <20120502120402.GM22191@redhat.com>
In-Reply-To: <20120502120402.GM22191@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2012 03:04 PM, Gleb Natapov wrote:
> KVM: Do not take reference to mm during async #PF
>
> It turned to be totally unneeded. The reason the code was introduced is
> so that KVM can prefault swapped in page, but prefault can fail even
> if mm is pinned since page table can change anyway. KVM handles this
> situation correctly though and does not inject spurious page faults.
>
>

Applied to master for 3.4, thanks.

-- 
error compiling committee.c: too many arguments to function

