Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0HXKJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 06:09:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56856 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab0HXKJC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 06:09:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kcDVeviCAvD0Dl0/1Q6sFiiSr3DiH1dOaqRHKODYid+5R6tM4ix05Fl18gr0WkNSQO
         a5EIkGNRF7FZv/6CCS8cLkuUoEtW4kdWi1N5mjawGSSrUGfIiK+qV/PeWl/JCEOcgNAk
         px91MKYcFKJjDKnLr0/YhvDSR7HUcThe8S2+8=
MIME-Version: 1.0
In-Reply-To: <496565EC904933469F292DDA3F1663E602CBDD3BB2@dlee06.ent.ti.com>
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
Date: Tue, 24 Aug 2010 13:09:01 +0300
Message-ID: <AANLkTimENxUjUWJQSZ1dmdkX_9hQ0pjat-kyR9oNjVxf@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 2, 2010 at 9:39 PM, Guzman Lugo, Fernando
<fernando.lugo@ti.com> wrote:
> I think, it would be good if we get rid of DMMPOOL size, if the liked list grow up as it is needed, there is no memory penalty of have all the possible iommu addresses valid (11000000 - FFFFFFFF). The reservation will only fail when there is no memory. If a software restriction is needed we could define a start and end addresses for iommu module (maybe as a parameter when the iommu handle for iva2 is got) and that boundaries can be taking in account at the moment of reserve the memory.

What happened to this?

IIUC what you are proposing is to remove the DMM pool completely, that
makes sense to me. However, is it really needed to finish the iommu
migration to do this?

> I think the reserve/unreserved dspbridge api can disappear and just return the da address in the map function.

This is something I've proposed before, so I agree :)

-- 
Felipe Contreras
