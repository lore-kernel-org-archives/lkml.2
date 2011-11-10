Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1KJTK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 14:10:59 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:60288 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1KJTKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 14:10:53 -0500
Message-ID: <4EBC219B.5010403@oracle.com>
Date: Thu, 10 Nov 2011 11:10:19 -0800
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/2] pciehp: wait 1000 ms before Link Training check
References: <4EB88238.4050409@oracle.com> <4EB8F434.6090003@jp.fujitsu.com> <4EB94A51.6070809@oracle.com> <4EB9A50D.1040302@oracle.com> <4EBB7F9B.8050703@jp.fujitsu.com> <4EBB7FF5.1040109@jp.fujitsu.com>
In-Reply-To: <4EBB7FF5.1040109@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4EBC21BA.0084,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2011 11:40 PM, Kenji Kaneshige wrote:

> We need to wait for 1000 ms after Data Link Layer Link Active (DLLLA)
> bit reads 1b before sending configuration request. Currently pciehp
> does this wait after checking Link Training (LT) bit. But we need it
> before checking LT bit because LT is still set even after DLLLA bit is
> set on some platforms.
> 
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>


Acked-by: Yinghai Lu <yinghai@kernel.org>
Tested-by: Yinghai Lu <yinghai@kernel.org>
