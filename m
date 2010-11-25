Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab0KYSJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 13:09:49 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51428 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab0KYSJr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 13:09:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hJoaB9hHCxRK+HkWBn3IQMx14ki+ZMVcD4KpMr2dg60CSh2FklINi1iuzOcqiRtdKt
         wKY25eh78WUCnpBwGHiq4aXOP8jAmPuApBDau5drXWIkmnJn7ZimlaS14lViFsMfjgO8
         jDqMzin3s2M/22zwHsXnPiJaU41M4KGIFTD6s=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=eTvdfPjgd0pGVmBx6zCB8yL3qNVq0MR1wH88b@mail.gmail.com>
References: <20101011145930.11fe570c.randy.dunlap@oracle.com>
	<1286889586-13483-1-git-send-email-mmarek@suse.cz>
	<20101029113731.5c7c54b9.sfr@canb.auug.org.au>
	<20101122114801.2eee4c4d.sfr@canb.auug.org.au>
	<AANLkTikwxBZUupGNA-gsrxWYpyCKK7wiVZu82WaUST-K@mail.gmail.com>
	<20101122135715.121b5eb7.sfr@canb.auug.org.au>
	<AANLkTi=io3tsuL8Hd2a0y8PyBYYAzb-gkJo1GfmpcF+L@mail.gmail.com>
	<AANLkTi=eTvdfPjgd0pGVmBx6zCB8yL3qNVq0MR1wH88b@mail.gmail.com>
Date: Thu, 25 Nov 2010 13:09:46 -0500
Message-ID: <AANLkTik-vnDTRTshpXE7ufjCM9AcfLGQV5v9CcjV=zJx@mail.gmail.com>
Subject: Re: [PATCH] Revert "kconfig: Temporarily disable dependency warnings"
From: Arnaud Lacombe <lacombar@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Michal Marek <mmarek@suse.cz>,
        randy.dunlap@oracle.com, linux-kbuild@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiyou.wangcong@gmail.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Nov 25, 2010 at 12:43 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> Now, commenting on your patches, you added a new statement, 'visible
> if...' for menus. Can we not change it to something like:
>
> -menu "I2C Algorithms"
> -       depends on !I2C_HELPER_AUTO
> +menu "I2C Algorithms" if !I2C_HELPER_AUTO
>
no because if_expr are translated internally in term of dependency,
which we don't want.

 - Arnaud
