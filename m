Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab2KPVyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 16:54:13 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:48514 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753341Ab2KPVyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 16:54:11 -0500
MIME-Version: 1.0
In-Reply-To: <50A5FAEB.7090202@gmail.com>
References: <50A1A7D9.2040506@gmail.com> <50A5FAEB.7090202@gmail.com>
From: Jesse Gross <jesse@nicira.com>
Date: Fri, 16 Nov 2012 13:53:45 -0800
Message-ID: <CAEP_g=9bP9iQv=59wYv32ppOhftpsarJM9ET3U9jDxwvatdbQg@mail.gmail.com>
Subject: Re: [PATCH v4 4/9] net: openvswitch: use this_cpu_ptr per-cpu helper
To: Shan Wei <shanwei88@gmail.com>
Cc: dev@openvswitch.org, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, cl@linux-foundation.org,
        Tejun Heo <htejun@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 12:35 AM, Shan Wei <shanwei88@gmail.com> wrote:
> Shan Wei said, at 2012/11/13 9:52:
>> From: Shan Wei <davidshan@tencent.com>
>>
>> just use more faster this_cpu_ptr instead of per_cpu_ptr(p, smp_processor_id());
>>
>>
>> Signed-off-by: Shan Wei <davidshan@tencent.com>
>> Reviewed-by: Christoph Lameter <cl@linux.com>
>
> Jesse Gross,  would you like to pick it up to your tree?

Applied, thanks.
