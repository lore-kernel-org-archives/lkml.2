Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab1KHVy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 16:54:58 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:40109 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab1KHVy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 16:54:56 -0500
Message-ID: <4EB9A50D.1040302@oracle.com>
Date: Tue, 08 Nov 2011 13:54:21 -0800
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [RFC PATCH] pciehp: Wait for link get trained in pci_check_link_status()
References: <4EB88238.4050409@oracle.com> <4EB8F434.6090003@jp.fujitsu.com> <4EB94A51.6070809@oracle.com>
In-Reply-To: <4EB94A51.6070809@oracle.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4EB9A52D.015A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2011 07:27 AM, Yinghai Lu wrote:

> On 11/08/2011 01:19 AM, Kenji Kaneshige wrote:
>>
>> What about the patch below? I think it's much simpler and has less impact.
> 
> Should work. will try it today.


yes, that works too.

Thanks

Yinghai
