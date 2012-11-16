Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab2KPIIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:08:45 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:45055 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab2KPIIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:08:44 -0500
Message-ID: <50A5F488.9080309@acm.org>
Date: Fri, 16 Nov 2012 09:08:40 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [patch,v3 00/10] make I/O path allocations more numa-friendly
References: <1352488687-19935-1-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1352488687-19935-1-git-send-email-jmoyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/12 20:17, Jeff Moyer wrote:
> This patch set makes memory allocations for data structures used in
> the I/O path more numa friendly by allocating them from the same numa
> node as the storage device.  I've only converted a handful of drivers
> at this point.  My testing showed that, for workloads where the I/O
> processes were not tied to the numa node housing the device, a speedup
> of around 6% was observed.  When the I/O processes were tied to the
> numa node of the device, there was no measurable difference in my test
> setup.  Given my relatively low-end setup[1], I wouldn't be surprised
> if others could show a more significant performance advantage.
>
> Comments would be greatly appreciated.

Sorry but I'm not familiar with any of the SCSI LLDs modified via this 
patch series. But I'm fine with the SCSI core patches in this series. So 
if you want you can add the following to the first five patches in this 
series:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Bart.

