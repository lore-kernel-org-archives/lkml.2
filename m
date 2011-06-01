Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab1FAU2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 16:28:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65075 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab1FAU2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 16:28:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SjbYsAVNjDWRByMPakja0RknpVYsS9G7a6UMPu1oOdCUCkWSrGUNe0FlTqqzCvMX10
         AOzj8LTRV5keg4UlnPtRpTOwgO1eTM+0Y0I6IjSlQTv5CjmmeOSZcWT6AXrGBme6tCyX
         5EsygTTAmQKViRuAoFhUiD1l8FsEVIqmTb0lw=
Message-ID: <4DE6A0E2.5040807@samsung.com>
Date: Wed, 01 Jun 2011 13:28:18 -0700
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, cpufreq@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH] CPUFREQ/S5PV210, EXYNOS4: Add Kconfig options for S5PV210
 and EXYNOS4 CPUfreq drivers
References: <1306476428-24808-1-git-send-email-dg77.kim@samsung.com>	<1306483489-10432-1-git-send-email-dg77.kim@samsung.com>	<4DE6977E.5080107@samsung.com> <20110601195418.GA30806@redhat.com>
In-Reply-To: <20110601195418.GA30806@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/11 12:54, Dave Jones wrote:
> On Wed, Jun 01, 2011 at 12:48:14PM -0700, Kukjin Kim wrote:
>
>   >  Dave, could you please see below? If you're ok, will submit remained
>   >  others for Samsung cpufreq drivers.
>
> I'm ok with the principle of the patch, though it doesn't seem to include
> any driver movement, so just applying this will break the compile.
> (If it happens in another patch, they should really go together to
>   not break bisecting)
>
Hi Dave,

OK, will submit others which include moving cpufreq driver soon.

If you don't mind I will make some branch to merge in both, my tree
and yours.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
