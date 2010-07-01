Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab0GAWvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:51:07 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34220 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab0GAWvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 18:51:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wE9KpRuxwI3DH3kGi7bPpLZWt6jHXY8fQcCqH3iMsRKoEXzlP2ANj5rkayLlErPiX1
         MX3h2SAC52eDqveuakeqCPfAFrN4BA8yzJ5o+06RIZvWM4+aJLx+xhIOwAW8O5Ckbh54
         s+0cjkF0s4yDFPl363T4OL7gZkouXhj11AFF4=
MIME-Version: 1.0
In-Reply-To: <4C2D0FF1.6010206@codeaurora.org>
References: <1277877350-2147-1-git-send-email-zpfeffer@codeaurora.org>
	<1277877350-2147-3-git-send-email-zpfeffer@codeaurora.org>
	<20100701101746.3810cc3b.randy.dunlap@oracle.com>
	<20100701180241.GA3594@basil.fritz.box>
	<1278012503.7738.17.camel@c-dwalke-linux.qualcomm.com>
	<20100701193850.GB3594@basil.fritz.box>
	<4C2D0FF1.6010206@codeaurora.org>
Date: Thu, 1 Jul 2010 17:51:01 -0500
Message-ID: <AANLkTilQnopqrS-KrR3btOIkH68fIEdipWFF6fkO6fNA@mail.gmail.com>
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
From: Hari Kanigeri <hari.kanigeri@gmail.com>
To: Zach Pfeffer <zpfeffer@codeaurora.org>
Cc: Andi Kleen <andi@firstfloor.org>, Daniel Walker <dwalker@codeaurora.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, mel@csn.ul.ie,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The VCMM takes the long view. Its designed for a future in which the
> number of IOMMUs will go up and the ways in which these IOMMUs are
> composed will vary from system to system, and may vary at
> runtime. Already, there are ~20 different IOMMU map implementations in
> the kernel. Had the Linux kernel had the VCMM, many of those
> implementations could have leveraged the mapping and topology management
> of a VCMM, while focusing on a few key hardware specific functions (map
> this physical address, program the page table base register).
>

-- Sounds good.
Did you think of a way to handle the cases where one of the Device
that is using the mapped address crashed ?
How is the physical address unbacked in this case ?

Hari
