Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab2JQGGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:06:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab2JQGGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:06:31 -0400
Message-ID: <507E4BD2.5070709@redhat.com>
Date: Wed, 17 Oct 2012 14:10:26 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120210 Thunderbird/10.0.1
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com
Subject: Re: [PATCH 0/3] Drivers: hv: vmbus
References: <1350073335-10575-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1350073335-10575-1-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2012 04:22 AM, K. Y. Srinivasan wrote:
> Fix a bug in the error path of vmbus_open(). As part of this also
> get rid of some unnecessary forward declarations as well as empty
> functions. I would like to thank Jason Wang<jasowang@redhat.com>
> for reporting the issues.
>
> K. Y. Srinivasan (3):
>    Drivers: hv: Get rid of unnecessary forward declarations
>    Drivers: hv: Cleanup error handling in vmbus_open()
>    Drivers: hv: Get rid of hv_ringbuffer_cleanup()
>
>   drivers/hv/channel.c      |   36 +++++++++++++-----------------------
>   drivers/hv/hyperv_vmbus.h |    1 -
>   drivers/hv/ring_buffer.c  |   11 -----------
>   3 files changed, 13 insertions(+), 35 deletions(-)
>
Thanks.

Acked-by: Jason Wang <jasowang@redhat.com>
