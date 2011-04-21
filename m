Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab1DUPAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 11:00:36 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47051 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab1DUPAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 11:00:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=rFdSpEuValQ599gO/YIDDEPFft6Qg7aufMuYnaGOekJfZuXpOuwmMbdxM0PLx58RT5
         wqhxLwdmIr3l1KaB8fJ/VFKtPreyP4NsOgSYjucYXYq8l2K8sjIfCdzhQ+sEEV/xX4lv
         DSyBSUEw1D7cPyqxpXzR1e+/7iI/raR4JWGTc=
MIME-Version: 1.0
Reply-To: wanlong.gao@gmail.com
In-Reply-To: <8BED86E3-758A-4370-883E-54E225F603EE@slimlogic.co.uk>
References: <8BED86E3-758A-4370-883E-54E225F603EE@slimlogic.co.uk>
Date: Thu, 21 Apr 2011 23:00:35 +0800
X-Google-Sender-Auth: H2y0Kgw2UEcFE-yCAr6o0ayKMUA
Message-ID: <BANLkTi=wvowAq6zKWnFz9d7OYXPXqsZXTw@mail.gmail.com>
Subject: Re: [PATCHv4 0/4] Initial TPS65910 PMIC driver
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com, sameo@linux.intel.com, Graeme Gregory <gg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/21/11, Jorge Eduardo Candelaria <jedu@slimlogic.co.uk> wrote:
> This is the initial version of the TPS65910 PMIC. This is a power management
> IC
> for multimedia products.
>
> It provides regulators that are able to supply power to
> dual processor cores and other components. The chip provides other modules
> including GPIO controller, RTC, etc.
>
> This driver will be able to support subsequent chip versions of the TPS6591x
> family.
>
> Changes from v3:
> - PATCH 4/4: Some old code was left behind. Remove it.
> - PATCH 4/4: Several operations have to read the value of a register, modify
>   it and then write it back. Create a new function that does the same.
>
> GIT: [PATCHv4 1/4] MFD: TPS65910: Add new mfd device for TPS65910
> GIT: [PATCHv4 2/4] TPS65910: GPIO: Add GPIO driver
> GIT: [PATCHv4 3/4] TPS65910: IRQ: Add interrupt controller
> GIT: [PATCHv4 4/4] TPS65910: Add tps65910 regulator driver--
The set seems good to me .
Thanks
Best regards .
Reviewed-by: Wanlong Gao <wanlong.gao@gmail.com>
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
