Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0JJQi3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 12:38:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47269 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab0JJQi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 12:38:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IiXb4H/UjrJXmvlQBm+5KMU7Jryv6U3y88D2SSbJ9PQbIghW9Ic5NYndUgdmEX4L3P
         nIa+v8R0mrlyTOKa/P7yXMoiHfOoGxTypuZcbRWUwGmJ9XzQ8bp9crHHh/jsIe9Ftk2q
         zkAPwxf6ak6r5/cPOBbrL1YR8NBkFgOM5kWYk=
MIME-Version: 1.0
In-Reply-To: <1282064161-21056-1-git-send-email-x0095840@ti.com>
References: <1282064161-21056-1-git-send-email-x0095840@ti.com>
Date: Sun, 10 Oct 2010 19:38:25 +0300
Message-ID: <AANLkTi=ohFYHTgbUNP3cZ5npAFP-toUwSWk3stvg4uYR@mail.gmail.com>
Subject: Re: [PATCH] iommu: fix end address of vm area comparation in alloc_iovm_area
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Fernando Guzman Lugo <x0095840@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Hiroshi.DOYU@nokia.com, h-kanigeri2@ti.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 7:56 PM, Fernando Guzman Lugo <x0095840@ti.com> wrote:
> End address of the vm area is .start + bytes -1., not start + byte.
> This patch fixes that issue by doing an inclusive comparison with
> tmp->da_start. This issue was preventing allocate an area of size
> exactly the same than the free area. I did no change the value of
> da_end of each vm area because it is used to get area size in
> several places.
>
> Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
> Acked-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

-- 
Felipe Contreras
