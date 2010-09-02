Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0IBIac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 04:30:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab0IBIab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 04:30:31 -0400
Message-ID: <4C7F60A1.3060607@redhat.com>
Date: Thu, 02 Sep 2010 11:30:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: MMU: lower the aduit frequency
References: <4C78FA00.8090606@cn.fujitsu.com> <4C7B867D.9080500@cn.fujitsu.com> <4C7B8759.60900@cn.fujitsu.com> <20100830154719.GB12707@amt.cnet> <4C7C687D.2000401@cn.fujitsu.com> <4C7E179D.6000405@redhat.com> <20100901162743.GA12870@amt.cnet>
In-Reply-To: <20100901162743.GA12870@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/01/2010 07:27 PM, Marcelo Tosatti wrote:
>
> Was just wondering whether there was a freeze. Patchset looks good
> (ratelimit can be disabled manually).
>

Ok, applied now.

-- 
error compiling committee.c: too many arguments to function

