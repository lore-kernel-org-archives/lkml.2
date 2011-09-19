Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674Ab1ISS63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:58:29 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:34376 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478Ab1ISS61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:58:27 -0400
Message-ID: <4E7790AC.6000801@oracle.com>
Date: Mon, 19 Sep 2011 11:57:48 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b3pre Thunderbird/3.1.13
MIME-Version: 1.0
To: Eric Blake <eblake@redhat.com>
CC: mtk.manpages@gmail.com, Josef Bacik <josef@redhat.com>,
        linux-man@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Man page doc for SEEK_DATA/SEEK_HOLE
References: <CAKgNAkhZSb0UfZz7N+gKRQD0r7gnC_3-VCB_ORio8ojczbCDvQ@mail.gmail.com> <4E77827C.3030202@redhat.com> <4E7789A1.4080501@oracle.com> <4E778D77.4070207@redhat.com>
In-Reply-To: <4E778D77.4070207@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090202.4E7790CD.00F6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2011 11:44 AM, Eric Blake wrote:
> I guess it should instead read:
>
> EINVAL whence is not valid (this error may be returned if whence is SEEK_DATA or SEEK_HOLE but the kernel does not support the operation).

Sure. Maybe add the kernel version. Support has been added in 3.1.
