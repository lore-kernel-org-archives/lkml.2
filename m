Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343Ab0LNPLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 10:11:03 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:52040 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880Ab0LNPLA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 10:11:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vPwKSVRApeRpQWOSRyGTkV0m22FyCCUeXpfy0CH86dfH1sKsWhdmQ7fAwLBH4Gyin0
         Ycy4w9ta5ZDkCxcpmuOsh0W+SRKcjZWit9nHvCyE1+U3hpW/uApb52JEHHlDi3Bof83o
         M39b0PZRnO6nIwBJXqlBU1hGgVKYSwxt9NZIA=
MIME-Version: 1.0
In-Reply-To: <1292332047-8206-1-git-send-email-fernando.lugo@ti.com>
References: <1292332047-8206-1-git-send-email-fernando.lugo@ti.com>
Date: Tue, 14 Dec 2010 17:10:54 +0200
Message-ID: <AANLkTim3i+nAV+isLy+rVZ9gtkeW408G_6BhJAbLJZTL@mail.gmail.com>
Subject: Re: [PATCH 0/4] omap: iovmm - fixes for iovmm module
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Fernando Guzman Lugo <fernando.lugo@ti.com>
Cc: Hiroshi.DOYU@nokia.com, linux@arm.linux.org.uk, h-kanigeri2@ti.com,
        felipe.contreras@nokia.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 3:07 PM, Fernando Guzman Lugo
<fernando.lugo@ti.com> wrote:

You are missing a description here.

> Version 6:
> * Rebase on Russell King branch.
>  - for details see:
>  http://marc.info/?l=linux-omap&m=129228495723001&w=2

Even if these patches are applied, iommu would still not be usable
form tidspbridge, you need at least this patch:
http://article.gmane.org/gmane.linux.ports.arm.omap/44753

Cheers.

-- 
Felipe Contreras
