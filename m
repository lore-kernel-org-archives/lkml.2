Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab0GUPD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 11:03:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64761 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab0GUPDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 11:03:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=i/T4gomKE9cjMEf5K4jLfO0sRYL2yptoSbp+6hcSrjCTrtUhEqp1Y7uEEsOVJpIpt7
         LIsVWfkxcMzvBx4VqVlTWALnN6x8xsR7Qrt6aQeAHuza6RfDxkAOK/hIG8+vNg/WKqce
         +uf9j1np6rVaQwRVykizFuWVV3xfXX8X8V5eU=
Message-ID: <4C470C2C.2070708@gmail.com>
Date: Wed, 21 Jul 2010 17:03:08 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        torvalds@linux-foundation.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, jeff@garzik.org,
        akpm@linux-foundation.org, rusty@rustcorp.com.au,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
        andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCHSET] workqueue: implement and use WQ_UNBOUND
References: <7b6bba36-5330-4e27-b7a9-3a4113b6b379@email.android.com> <21485.1279717725@redhat.com> <4C470B46.4040604@kernel.org>
In-Reply-To: <4C470B46.4040604@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a bit of clarification.

On 07/21/2010 04:59 PM, Tejun Heo wrote:
>> I should've been clearer: As I understand it, normal (unbound) worker items

In workqueue land, normal workqueues would be bound to CPUs while
workers for WQ_UNBOUND workqueues aren't affined to any specific CPU.

Thanks.

-- 
tejun
