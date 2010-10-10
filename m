Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab0JJRct (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 13:32:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40420 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab0JJRcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 13:32:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Io935rv74B8uwyOafKx/F3yooqSdiZzeoaI72oeCnwg8F60xpRQJjtdY/YxhVBILfu
         ub1SrjpWmgFMn4/lNWCHcSYsCd0mehPagsS9G3R3TxaDVkqovSmoWc9FxUxgDVjSAiQl
         tKi2OghVuZ7WvXzZpi5w3RgnMI0nrLWovZu/0=
MIME-Version: 1.0
In-Reply-To: <1286310944-25035-1-git-send-email-x0095840@ti.com>
References: <1286310944-25035-1-git-send-email-x0095840@ti.com>
Date: Sun, 10 Oct 2010 20:32:45 +0300
Message-ID: <AANLkTimoTmhAw11jJihiuyByzKZ9KTFHvx6iw8oeLCGg@mail.gmail.com>
Subject: Re: [PATCHv3 00/11] staging tidspbridge: iommu migration
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

On Tue, Oct 5, 2010 at 11:35 PM, Fernando Guzman Lugo <x0095840@ti.com> wrote:
> This set of patches remove the dspbridge custom mmu
> implementation and use iommu module instead.

I have tried this, it works for simple tests, but not real use-cases.
I applied all your iommu patches. How did you test this?

-- 
Felipe Contreras
