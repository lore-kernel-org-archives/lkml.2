Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab0HXTOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 15:14:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51456 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab0HXTN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 15:13:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EzuVAVgaxlCITyJpIZPKu4Iqt5kQdB7Caqzksbm0eY+7siVU9FsmKbZBrDPZLGcC3J
         jqe0MjuCXN59gMuLwM/BQIWnPZTa8ajPSg3E9wnj4nMvMYNKLDhvnpqiIzYqRLLOvtwx
         jB6/LfODDrcVTi+nsffcssLSrkBDqxocKFZxs=
MIME-Version: 1.0
In-Reply-To: <496565EC904933469F292DDA3F1663E602F0FA3995@dlee06.ent.ti.com>
References: <1277943660-4112-1-git-send-email-x0095840@ti.com>
	<1277943660-4112-2-git-send-email-x0095840@ti.com>
	<1277943660-4112-3-git-send-email-x0095840@ti.com>
	<1277943660-4112-4-git-send-email-x0095840@ti.com>
	<1277943660-4112-5-git-send-email-x0095840@ti.com>
	<1277943660-4112-6-git-send-email-x0095840@ti.com>
	<1277943660-4112-7-git-send-email-x0095840@ti.com>
	<1277943660-4112-8-git-send-email-x0095840@ti.com>
	<1277943660-4112-9-git-send-email-x0095840@ti.com>
	<8F7AF80515AF0D4D93307E594F3CB40E4CAD34D5@dlee03.ent.ti.com>
	<496565EC904933469F292DDA3F1663E602CBDD3ADE@dlee06.ent.ti.com>
	<8F7AF80515AF0D4D93307E594F3CB40E4CAD39F6@dlee03.ent.ti.com>
	<496565EC904933469F292DDA3F1663E602CBDD3BB2@dlee06.ent.ti.com>
	<AANLkTimENxUjUWJQSZ1dmdkX_9hQ0pjat-kyR9oNjVxf@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA3883@dlee06.ent.ti.com>
	<AANLkTi=NuPu6bvv6KF7sXRp02bvfz7oRkG1SG1PstA-H@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA397F@dlee06.ent.ti.com>
	<AANLkTinaJ=xn_CAJznVtMcA0nwK_-gbo05OQKM7PuoYA@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA3995@dlee06.ent.ti.com>
Date: Tue, 24 Aug 2010 22:13:57 +0300
Message-ID: <AANLkTinjMujus-28DcLzZ+16GAGpLohwhPhuTi5uKhB8@mail.gmail.com>
Subject: Re: [PATCH 8/9] dspbridge: add map support for big buffers
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Cc: "Kanigeri, Hari" <h-kanigeri2@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "hiroshi.doyu@nokia.com" <hiroshi.doyu@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 10:05 PM, Guzman Lugo, Fernando
<fernando.lugo@ti.com> wrote:
>> I've heard there are some problems regarding DMM, and since
>> you say you have already done the changes, and since iommu
>> migration is not yet ready AFAIK, it might make sense to go
>> for option b).
>>
>> Anyway, thanks for the clarification :)
>
> But DMM is used in this momment, it is after the IOMMU migration
> When DMM is not needed anymore. So we need to go for option a).

Oh, I actually meant the DMM pool.

a) 1. Migrate to iommu, 2. Remove DMM completely
b) 1. Remove DMM pool, 2. Migrate to iommu 3. Remove DMM completely

-- 
Felipe Contreras
