Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab2BBDP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 22:15:56 -0500
Received: from tuxonice.net ([96.126.116.212]:42116 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887Ab2BBDPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 22:15:54 -0500
X-Bogosity: Unsure, spamicity=0.520000
Message-ID: <4F29FFE5.6010601@tuxonice.net>
Date: Thu, 02 Feb 2012 14:15:49 +1100
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Tejun Heo <tj@kernel.org>, rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com,
        linux-pm@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM/Freezer: Thaw only kernel threads if freezing of kernel
 threads fails
References: <20120201223105.6669.12718.stgit@srivatsabhat.in.ibm.com> <20120201223647.GB19837@google.com> <4F29C3E3.1040108@linux.vnet.ibm.com>
In-Reply-To: <4F29C3E3.1040108@linux.vnet.ibm.com>
X-TagToolbar-Keys: D20120202141549164
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 02/02/12 09:59, Srivatsa S. Bhat wrote:
> On 02/02/2012 04:06 AM, Tejun Heo wrote:
> 
>> On Thu, Feb 02, 2012 at 04:01:12AM +0530, Srivatsa S. Bhat wrote:
>>> So, modify freeze_kernel_threads() to thaw only kernel threads in case of
>>> freezing failure.
>>>
>>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>>
>> Acked-by: Tejun Heo <tj@kernel.org>

Acked-by: Nigel Cunningham <nigel@tuxonice.net>

Regards,

Nigel

-- 
Evolution (n): A hypothetical process whereby improbable
events occur with alarming frequency, order arises from chaos, and
no one is given credit.
