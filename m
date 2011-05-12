Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab1ELMPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 08:15:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65415 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733Ab1ELMPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 08:15:06 -0400
Date: Thu, 12 May 2011 14:14:57 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
cc: Josh Wu <josh.wu@atmel.com>, mchehab@redhat.com,
        linux-media@vger.kernel.org, lars.haring@atmel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI)
 support
In-Reply-To: <20110512114530.GE18952@game.jcrosoft.org>
Message-ID: <Pine.LNX.4.64.1105121413220.24486@axis700.grange>
References: <1305186138-5656-1-git-send-email-josh.wu@atmel.com>
 <20110512114530.GE18952@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:SM8Mc/QN75U7ylHqv0irRN+M1GgdcJVUACv4iOc8CX5
 BQ7rU4Gypu8ihu2qGXeLzRsOB74ShEMOttIksIpEDyNKfRh8WW
 1xSYoIia51C6+1TUiahLERWkHBTA6ezOLc4w+0BqdLuiy0pXGT
 wstIQXoa/lRy9Y8J8NlFKzsmtugeB2pJNqT0wBclwe0vd2Irpj
 HzsxIRIwjxk2NdY5ppGzaNEabDFezvFTah3R1U+mkI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011, Jean-Christophe PLAGNIOL-VILLARD wrote:

[snip]

> > +	if (0 == *nbuffers)
> please invert the test

Don't think this is required by CodingStyle or anything like that. If it 
were, you'd have to revamp half of the kernel.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
