Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934510Ab2DLQMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 12:12:10 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:62861 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932970Ab2DLQMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 12:12:08 -0400
Message-ID: <4F86FED6.7080900@tilera.com>
Date: Thu, 12 Apr 2012 12:12:06 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
        David Howells <dhowells@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irq_work: fix compile failure on tile from missing include
References: <201204111627.q3BGRJ5m005114@farm-0002.internal.tilera.com> <4F86FE82.1040007@windriver.com>
In-Reply-To: <4F86FE82.1040007@windriver.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/2012 12:10 PM, Paul Gortmaker wrote:
> On 12-04-11 12:21 PM, Chris Metcalf wrote:
>> Building with IRQ_WORK configured results in
>>
>> kernel/irq_work.c: In function ‘irq_work_run’:
>> kernel/irq_work.c:110: error: implicit declaration of function ‘irqs_disabled’
>>
>> The appropriate header just needs to be included.
>>
>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> Hi Chris,
>
> I've got an alpha fix and an itanic fix left wrt. the system.h
> fallout to get pulled; I can bundle this system.h fix with those
> if you want.

That would be great; thanks.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

