Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621Ab0LNSJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 13:09:32 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:58253 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758335Ab0LNSJa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 13:09:30 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTim3i+nAV+isLy+rVZ9gtkeW408G_6BhJAbLJZTL@mail.gmail.com>
References: <1292332047-8206-1-git-send-email-fernando.lugo@ti.com>
	<AANLkTim3i+nAV+isLy+rVZ9gtkeW408G_6BhJAbLJZTL@mail.gmail.com>
Date: Tue, 14 Dec 2010 12:09:18 -0600
Message-ID: <AANLkTimT99yQ3yShp4OgxEM5MJZHdS9x+BByH-=w9UHC@mail.gmail.com>
Subject: Re: [PATCH 0/4] omap: iovmm - fixes for iovmm module
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Hiroshi.DOYU@nokia.com, linux@arm.linux.org.uk, h-kanigeri2@ti.com,
        felipe.contreras@nokia.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 9:10 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Tue, Dec 14, 2010 at 3:07 PM, Fernando Guzman Lugo
> <fernando.lugo@ti.com> wrote:
>
> You are missing a description here.

Yes, I forget the description but it is pretty much the same than the subject.

>
>> Version 6:
>> * Rebase on Russell King branch.
>>  - for details see:
>>  http://marc.info/?l=linux-omap&m=129228495723001&w=2
>
> Even if these patches are applied, iommu would still not be usable
> form tidspbridge, you need at least this patch:
> http://article.gmane.org/gmane.linux.ports.arm.omap/44753

I think Hari can take that patch too.

Regards,
Fernando.

>
> Cheers.
>
> --
> Felipe Contreras
>
