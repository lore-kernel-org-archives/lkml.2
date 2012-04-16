Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab2DPD1w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 23:27:52 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:34424 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab2DPD1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 23:27:52 -0400
Message-ID: <4F8B91B0.4000601@linux.vnet.ibm.com>
Date: Mon, 16 Apr 2012 11:27:44 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 05/16] KVM: MMU: abstract spte write-protect
References: <4F87FA69.5060106@linux.vnet.ibm.com> <4F87FBE1.200@linux.vnet.ibm.com> <20120414112635.0940cc4628320821a88646fc@gmail.com>
In-Reply-To: <20120414112635.0940cc4628320821a88646fc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041603-8256-0000-0000-00000200F111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2012 10:26 AM, Takuya Yoshikawa wrote:

> On Fri, 13 Apr 2012 18:11:45 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> +/* Return true if the spte is dropped. */
> 
> Return value does not correspond with the function name so it is confusing.
> 


That is why i put comment here.

> People may think that true means write protection has been done.
> 


You have a better name?

