Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab2KMTDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 14:03:10 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:48151 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab2KMTDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:03:08 -0500
Message-ID: <50A29947.3040709@us.ibm.com>
Date: Tue, 13 Nov 2012 11:02:31 -0800
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Shan Wei <shanwei88@gmail.com>
CC: tglx@linutronix.de, Kernel-Maillist <linux-kernel@vger.kernel.org>,
        cl@linux-foundation.org
Subject: Re: [PATCH v4 8/9] clocksource: use this_cpu_ptr per-cpu helper
References: <50A1A80A.40302@gmail.com>
In-Reply-To: <50A1A80A.40302@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111319-3620-0000-0000-0000005874D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 05:53 PM, Shan Wei wrote:
> From: Shan Wei <davidshan@tencent.com>
>
>
> Signed-off-by: Shan Wei <davidshan@tencent.com>
> Reviewed-by: Christoph Lameter <cl@linux.com>

Please provide a changelog (even for trivial changes) in the future.

Applied to my tree.

thanks
-john

