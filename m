Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab1LHPCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 10:02:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab1LHPCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 10:02:39 -0500
Message-ID: <4EE0D146.4050506@redhat.com>
Date: Thu, 08 Dec 2011 10:01:26 -0500
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: Yinghai Lu <yinghai.lu@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ibft: Fix finding ibft with ACPI tables
References: <4EE073BB.6080403@oracle.com> <20111208142958.GA4096@andromeda.dapyr.net>
In-Reply-To: <20111208142958.GA4096@andromeda.dapyr.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2011 09:29 AM, Konrad Rzeszutek Wilk wrote:

> Peter, do you know if Anaconda scans the dmesg for the 'iBFT'? I presume
> not (since the SysFS exists).

It does not.

-- 
         Peter
