Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab0LWBb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 20:31:27 -0500
Received: from mail-wy0-f194.google.com ([74.125.82.194]:34505 "EHLO
	mail-wy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab0LWBb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 20:31:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=LOaBh3pSWVquktd8OusSo1in4HOaBp4uTv9pXBN25lnu0GP80O42CD+uabGChaj9jK
         i7Rx85RwCfkMkKEQxZT7Vb4jv3WR/zjRmwo41BfnIbyPeY/MYZyzdk1LBp7dBIMibA+h
         SaOR01HyFKJI5YV+BNSQt8M/S5qM9Yds9P0qY=
MIME-Version: 1.0
In-Reply-To: <AANLkTimirgsuoM2che_ocrkvCZqGu6xEJjrjdmt9-69p@mail.gmail.com>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com>
	<20101221182037.GA4783@n2100.arm.linux.org.uk>
	<20101222122904.GC14693@n2100.arm.linux.org.uk>
	<AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com>
	<20101223001012.GF29368@n2100.arm.linux.org.uk>
	<AANLkTimirgsuoM2che_ocrkvCZqGu6xEJjrjdmt9-69p@mail.gmail.com>
Date: Wed, 22 Dec 2010 17:31:25 -0800
X-Google-Sender-Auth: mENqBsEJs17MH4sxAO-GPqtaFPk
Message-ID: <AANLkTikP+JZkN7AjqaNfHY8jZ7bVsV-af=YR=MTdfnNU@mail.gmail.com>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
From: Dan Williams <dan.j.williams@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        yuanyabin1978@sina.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 5:11 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Drivers that do not
> want to meet the constraints expected by the opportunistic offload
> clients should do what ste_dma40 does and add "depends on !(NET_DMA ||
> ASYNC_TX_DMA)"

Sorry I was looking at a local change it does not do this today, but I
recommended it to workaround the broken >64k transfer support that was
reported recently.

--
Dan
