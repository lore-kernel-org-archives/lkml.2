Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab0LVX43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 18:56:29 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50077 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab0LVX42 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 18:56:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xNp96C9xuIv+dfxzFCTuvGH1KMbUH5rPQ9iTHbkyii+s+kzyIo7/QJ07aJM0vN8j4U
         aRFSZTdOzevQz15QCmVqFf+F7vPTD4xIzTOJlc/GcLfuReKdTTZwX2bCyG9TneZNHvBZ
         SHdewyRj36eO7xBtksFntmcgbPEFjjBJ9jg+E=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1012221444300.14483@axis700.grange>
References: <Pine.LNX.4.64.1012221444300.14483@axis700.grange>
Date: Wed, 22 Dec 2010 15:56:26 -0800
X-Google-Sender-Auth: e5tOr4sZiYuW0EhsMuLwod4dyaw
Message-ID: <AANLkTim-1xCmk1S3KhdFazYCizzex0C5c_PtpjQoVkvj@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: provide dummy functions for DMA_ENGINE=n
From: Dan Williams <dan.j.williams@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 5:46 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> This lets drivers, optionally using the dmaengine, build with DMA_ENGINE
> unselected.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  include/linux/dmaengine.h |   13 ++++++++++---
>  1 files changed, 10 insertions(+), 3 deletions(-)

Is this fixing build errors, or is this just relieving drivers from
needing to surround calls to dma_{request|release}_channel() with
ifdef CONFIG_DMA_ENGINE?  The former makes this more urgent, the
latter can wait for the next merge window.

--
Dan
