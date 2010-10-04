Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab0JDPgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 11:36:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44993 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab0JDPgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 11:36:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UrBguUoAjUdX9KNPfQi8w00uZHtJCJiZU+WMHBc4OX4qxM+QFrc1Jz9380YbNx0vYs
         MDtfW0h45MiVds4Izlt1ucm1+oTxMM7jNytnAlnZJZEd3JMY+xw0aajkxIHpdpGrRW9v
         DN2BcrJcIIrJCsZb1KQfGAiXAV6uz1a3yDVqw=
MIME-Version: 1.0
In-Reply-To: <1285899178-14413-1-git-send-email-x0095840@ti.com>
References: <1285899178-14413-1-git-send-email-x0095840@ti.com>
Date: Mon, 4 Oct 2010 18:36:10 +0300
Message-ID: <AANLkTik2bj_nr-WG+xF7C3OQaq5biGejGDnb2z2xob8D@mail.gmail.com>
Subject: Re: [PATCHv2 00/11] staging tidspbridge: iommu migration
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Fernando Guzman Lugo <x0095840@ti.com>
Cc: gregkh@suse.de, felipe.contreras@nokia.com, ameya.palande@nokia.com,
        nm@ti.com, Hiroshi.DOYU@nokia.com, ohad@wizery.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Oct 1, 2010 at 5:12 AM, Fernando Guzman Lugo <x0095840@ti.com> wrote:
> This set of patches remove the dspbridge custom mmu
> implementation and use iommu module instead.

I suppose the driver wouldn't work in the middle of this patch series.
I wanted to try this patches and experiment to see if I could come
with a version that doesn't break in the middle, but it turns out the
driver doesn't work at all on 2.6.36, I just sent an email with the
details.

Have you tried with the mainline? Or am I missing something?

-- 
Felipe Contreras
