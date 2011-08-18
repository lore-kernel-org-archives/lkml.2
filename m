Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab1HRLvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 07:51:14 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60636 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab1HRLvL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 07:51:11 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1108180649040.10458@p34.internal.lan>
References: <alpine.DEB.2.02.1108180649040.10458@p34.internal.lan>
Date: Thu, 18 Aug 2011 19:51:10 +0800
Message-ID: <CAM_iQpWPaavsa7gSURP5CL8+Es2P5rEdtLRmrOx+wQkThX7v9w@mail.gmail.com>
Subject: Re: 3.1-rc2: CONFIG_NUMA Question
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 6:51 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Hi,
>
> I have a SuperMicro X8DTH-6F motherboard with 2 cpus it has NUMA options in
> the BIOS; what parameters/should I be using for the NUMA options in the
> kernel?
>
>  | |    [*] Numa Memory Allocation and Scheduler Support                 | |
>  | |    [ ] Old style AMD Opteron NUMA detection                         | |
>  | |    [*] ACPI NUMA detection                                          | |
>  | |    [ ] NUMA emulation                                               | |
>  | |    (6) Maximum NUMA Nodes (as a power of 2)                         | |
>

That is Intel processor, right? If so, the things you selected here are enough,
the rest two is not what you need.

> Specifically, the maximum number of NUMA nodes?  Will this help to increase
> performance of large memory allocations/is there any downside
> to enabling this feature?

The max of NUMA nodes is specified by CONFIG_NODES_SHIFT,
in your case, it is 6, which means it supports up to 2^6 nodes.

If your hardware supports NUMA, yes, that certainly help to increase
the performance.

Thanks.
