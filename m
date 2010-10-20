Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab0JTIqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 04:46:07 -0400
Received: from smtp.nokia.com ([192.100.122.233]:64043 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab0JTIqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 04:46:05 -0400
Date: Wed, 20 Oct 2010 11:45:16 +0300 (EEST)
Message-Id: <20101020.114516.189725260.Hiroshi.DOYU@nokia.com>
To: felipe.contreras@gmail.com
Cc: x0095840@ti.com, felipe.contreras@nokia.com, david.cohen@nokia.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCHv4 4/4] iommu: create new api to set valid da range
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <AANLkTimSQabHv3AOFFR4m3POjmuGvN18u7TNsPyauH8D@mail.gmail.com>
References: <1287542932-14206-4-git-send-email-x0095840@ti.com>
	<1287542932-14206-5-git-send-email-x0095840@ti.com>
	<AANLkTimSQabHv3AOFFR4m3POjmuGvN18u7TNsPyauH8D@mail.gmail.com>
X-Mailer: Mew version 7.0.50 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Oct 2010 08:45:22.0836 (UTC) FILETIME=[22200D40:01CB7033]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "ext felipe.contreras@gmail.com" <felipe.contreras@gmail.com>
Subject: Re: [PATCHv4 4/4] iommu: create new api to set valid da range
Date: Wed, 20 Oct 2010 10:35:50 +0200

> On Wed, Oct 20, 2010 at 5:48 AM, Fernando Guzman Lugo <x0095840@ti.com> wrote:
>> Some IOMMUs cannot use the whole 0x0 - 0xFFFFFFFF range.
>> With this new API the valid range can be set.
>>
>> Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
> 
> I don't see the point in having an API. It could be done through
> platform data, and the usage of 0xFFFFF000 instead of ULONG_MAX is
> independent of this.

Using platform data is better, but why dropping da_end?

