Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab0LCJgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 04:36:44 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59227 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab0LCJgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 04:36:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=R98i5r4JvKb6Bi8RdZHcZi1Rs8c1xGQVL9yBNzHfejt9UayQUjntqLYGb9sHJ6vT1C
         I7TgfC+rgXkHTSdzqtcVO818syGTOLvGUhpc72LBzD841/Clpyao3gHQS5YSlrSti309
         YNQbw+quq9gInOEooqzkNfzPt10HdJPbESMqc=
MIME-Version: 1.0
In-Reply-To: <1288660377.20990.1.camel@mola>
References: <1288660377.20990.1.camel@mola>
Date: Fri, 3 Dec 2010 01:36:41 -0800
X-Google-Sender-Auth: TshyGxVnFKYdLryzuPgH5phnN34
Message-ID: <AANLkTi=62LyRmXTGzXtzx1snoA_1k75FaDYv7SCm0e02@mail.gmail.com>
Subject: Re: [PATCH] dma: imx-dma: fix imxdma_probe error path
From: Dan Williams <dan.j.williams@intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Pengutronix <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 6:12 PM, Axel Lin <axel.lin@gmail.com> wrote:
> otherwise, i will be -1 inside the latest iteration of the while loop.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---

Catching up on the backlog... applied.
