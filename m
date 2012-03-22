Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab2CVNPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 09:15:40 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36938 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608Ab2CVNPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 09:15:38 -0400
Message-ID: <4F6B25A4.4090006@mvista.com>
Date: Thu, 22 Mar 2012 17:14:12 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Rafal Prylowski <prylowski@metasoft.pl>
CC: Ryan Mallon <rmallon@gmail.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
References: <4F683B36.8090101@metasoft.pl> <4F6A78ED.3050403@gmail.com> <4F6AF845.9070209@metasoft.pl>
In-Reply-To: <4F6AF845.9070209@metasoft.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 22-03-2012 14:00, Rafal Prylowski wrote:

>> I haven't looked through the patch yet, since I'm waiting on more
>> information from Mika and Hartley's testing.

>> However, the commit log doesn't tell me why we want this change. Is it a
>> performance improvement? If so, do you have some numbers that we can
>> paste into the commit log?

> In principle, using double buffering should be faster than using only
> one buffer and disabling/enabling channel each time. But my measurements
> doesn't show any significant change.

> The real reason for this change is that current code is not 100% reliable
> in IDE-DMA (I'm planning to submit ep93xx ide driver to linux-ide soon).

    IDE or libata driver? Asking because IDE drivers are not accepted anymore.

WBR, Sergei
