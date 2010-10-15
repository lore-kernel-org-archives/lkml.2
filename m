Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab0JOUSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:18:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48849 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756Ab0JOUSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:18:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KJOBDNQzU+XPqZeRPQotKRUscf/uFx2m8Ojltgsc1gbw47q27n9rN7rqqsO/jKfKPf
         TbPx4lz8HdjkvLCB4YeXq4cAhTxraUt/E1bEMkKDMtFS+b+StLnbLIqKRv4VfkXNjS/J
         wdz2KXfVQxjwtpNoI+fdmUz9eHf5V/OCDKigs=
MIME-Version: 1.0
In-Reply-To: <496565EC904933469F292DDA3F1663E602F4881816@dlee06.ent.ti.com>
References: <1286310944-25035-1-git-send-email-x0095840@ti.com>
	<AANLkTimoTmhAw11jJihiuyByzKZ9KTFHvx6iw8oeLCGg@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F47B2BB1@dlee06.ent.ti.com>
	<AANLkTim6XRgnefA0vmRNeW=TONhxz68WYAjuA96LqWOj@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F47B3002@dlee06.ent.ti.com>
	<AANLkTik3hhWy+tRxThtrbwNXTssV7nf9+_LGn5Ct3iet@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F48817EF@dlee06.ent.ti.com>
	<AANLkTi=juk+824k1R8mJrDostKhRz+nRNqj9E-rNYWrv@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F4881816@dlee06.ent.ti.com>
Date: Fri, 15 Oct 2010 23:10:08 +0300
Message-ID: <AANLkTikfn9w-FMKXOVXibwHVy4vt72GdveDLVv0z3GmT@mail.gmail.com>
Subject: Re: [PATCHv3 00/11] staging tidspbridge: iommu migration
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "Menon, Nishanth" <nm@ti.com>,
        "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 7:53 PM, Guzman Lugo, Fernando
<fernando.lugo@ti.com> wrote:
>> If you want I can provide my working branch on top of .36-rc8
>> with next-staging merged. If I revert your patches, it works fine.
>
> That could be interested. Can you send me the link?

There you go:
git://gitorious.org/~felipec/linux-omap/felipec.git (fc-dsp-work)

HEAD works, HEAD^ doesn't.

-- 
Felipe Contreras
