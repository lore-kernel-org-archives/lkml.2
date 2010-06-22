Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab0FVXeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 19:34:46 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:49487 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab0FVXeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 19:34:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=mtQvd1h0sgehA8Z1M3EmFovCNV8rpU0YHeYx2ypaLnRae6KGlaJWEX626Z27QT5CDW
         jpPQ19V55eTKKGhuFhFcNMFVwstRB/FJJQcJKy/ElcCB/iH31NKYcHR4WYRAMKzS2pbz
         GgvMLfRnmwsNOiQZiSUP9ARDI5PuSS9qX1SeM=
MIME-Version: 1.0
In-Reply-To: <20100621044030.GC29997@linux-sh.org>
References: <Pine.LNX.4.64.1006071312060.12965@axis700.grange>
	<20100621044030.GC29997@linux-sh.org>
Date: Tue, 22 Jun 2010 16:34:43 -0700
X-Google-Sender-Auth: HDpEuETcwoTv5vK0l5pqp6f-odw
Message-ID: <AANLkTil-xnYsCoK94MT8l2rwjDhifTWlkfukcGZ57Viu@mail.gmail.com>
Subject: Re: [PATCH] initialise DMA engine before MMC
From: Dan Williams <dan.j.williams@intel.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org,
       "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 20, 2010 at 9:40 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Mon, Jun 07, 2010 at 01:16:36PM +0200, Guennadi Liakhovetski wrote:
>> To use DMA engine based DMA with MMC in a non-modular build, the DMA
>> engine has to initialise before MMC.
>>
>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>
> Dan, any objections to this?

No, objections, you can add my acked-by.
