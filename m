Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab2DIOo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 10:44:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34558 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab2DIOoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 10:44:24 -0400
MIME-Version: 1.0
X-Originating-IP: [121.7.238.24]
In-Reply-To: <4F81510B.60406@cn.fujitsu.com>
References: <CAMVG2ss5WzwhgPunD5greRii1HFuEYt1TMQwxgUNitrpHtguVA@mail.gmail.com>
	<CAMVG2st4VPbujSY1hH+VjbR1gxCR0ZEGznrObYMWnpgo++Ynug@mail.gmail.com>
	<4F81510B.60406@cn.fujitsu.com>
Date: Mon, 9 Apr 2012 22:44:23 +0800
Message-ID: <CAMVG2staWGn6uUic3=ALYpT8MpkED3xUP2WCuMUnRSVcsjEN0A@mail.gmail.com>
Subject: Re: [3.4-rc1] attempt to access beyond end of device and livelock
From: Daniel J Blueman <daniel@quora.org>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        Linux BTRFS <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 April 2012 16:49, Liu Bo <liubo2009@cn.fujitsu.com> wrote:
> On 04/06/2012 07:36 PM, Daniel J Blueman wrote:
>> Hi Josef, Chris,
>>
>> When testing BTRFS with RAID 0 metadata on linux-3.4-rc1, we see
>> discard ranges exceeding the end of the block device [1], potentially
>> causing dataloss; when this occurs, filesystem writeback becomes
>> catatonic due to continual resubmission.
[]
> Thanks for the report, this bug shows we've miscalculated the length of discard extents.
>
> I'll send a patch for this soon.

The patch test out well here on 3.4-rc2. Thanks Bo!

Daniel
-- 
Daniel J Blueman
