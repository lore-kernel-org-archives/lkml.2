Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab2DMOSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 10:18:39 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55907 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab2DMOSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 10:18:37 -0400
Message-ID: <4F8835B8.2060400@garzik.org>
Date: Fri, 13 Apr 2012 10:18:32 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [RFC] enable FUA support in libata
References: <20120413081104.GA4953@gmail.com>
In-Reply-To: <20120413081104.GA4953@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2012 04:11 AM, Zheng Liu wrote:
> Hi Jeff and list,
>
> Recently I met a problem about FUA support of SATA disk.  In my machine,
> it has a SATA disk that supports FUA feature.  But after system starts
> up, it displays that the disk cannot support FUA from dmesg.
>
> I notice this commit (c3c013a2).  It disables FUA support in all of SATA
> disk.  But the commit log is too simple to know why we should disable
> FUA support in libata.  Could you please explain it?  Thank you.

FUA support in the block layer wanted speed and guarantees that early 
FUA drives were simply not providing.



