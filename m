Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab1JSDdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 23:33:50 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48752 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab1JSDdt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 23:33:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=CjKr2pSYQBJm6mIWJLBZro7/+FyLACpBxdFOkbiSrsAuz4wXB5bAiDY2wnoAH2Z2d
	M0U6XJNxUjxXLVPs32iew==
MIME-Version: 1.0
In-Reply-To: <4E9E4007.80502@huawei.com>
References: <4E7D7468.4040506@huawei.com> <4E83E27E.5090608@linux.intel.com>
 <4E83E8EF.30806@huawei.com> <CAErSpo63mEbhmDCYpYQZ7hmoEz3A03pbS513myt+GrwPG+pK5w@mail.gmail.com>
 <4E9D7248.7060100@huawei.com> <4E9E3D8B.7060406@linux.intel.com> <4E9E4007.80502@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 18 Oct 2011 21:33:27 -0600
Message-ID: <CAErSpo43eJg59u_cioSksEV_VP1sZPFM1H07HZDD_is-QbrfGQ@mail.gmail.com>
Subject: Re: [PATCH v5] acpi: Fix CPU hot removal problem
To: "canquan.shen" <shencanquan@huawei.com>
Cc: Chen Gong <gong.chen@linux.intel.com>, len.brown@intel.com,
        "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "yakui.zhao@intel.com" <yakui.zhao@intel.com>,
        "xiaowei.yang@huawei.com" <xiaowei.yang@huawei.com>,
        hanweidong <hanweidong@huawei.com>, linqiangmin@huawei.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        khalid.aziz@hp.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 9:12 PM, canquan.shen <shencanquan@huawei.com> wrote:
> On 2011/10/19 11:01, Chen Gong wrote:
>>
>> 于 2011/10/18 20:34, canquan.shen 写道:
>>>
>>> Hi Len and Chen Gong,
>>> What's you opinion on this patch?
>>>
>>> Thanks.
>>
>> I'm OK to this patch. Myabe you can ask Bjorn
>> for his "signed-off-by"
>>
>> .
>>
>
> Thanks, Chen Gong.
>
> Hi Bjorn,
>
>  What's you opinion on this patch?

Looks good to me.

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
