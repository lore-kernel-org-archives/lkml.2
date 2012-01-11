Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab2AKQ6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:58:05 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58924 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757195Ab2AKQ6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:58:02 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <201201111646.24731.arnd@arndb.de>
References: <20120111133146.990e2b7115c9fa80e8fc3234@canb.auug.org.au>
	<201201111450.02798.arnd@arndb.de>
	<4F0DB16B.3010302@atmel.com>
	<201201111646.24731.arnd@arndb.de>
Date: Wed, 11 Jan 2012 08:58:00 -0800
Message-ID: <CAOesGMhNOd6uXQLASn2ipryq8kXvCv_t-6Oioyfxbk2Mcvn9PA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the v4l-dvb tree with the arm-soc tree
From: Olof Johansson <olof@lixom.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, "Wu, Josh" <Josh.wu@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 8:46 AM, Arnd Bergmann <arnd@arndb.de> wrote:

> Agreed. How about if you rebase the few other (non-ISI) patches that
> I had in arm-soc onto v3.2 and send me an updated pull request so
> I can send them on? There's no reason to hold them up.

Just to clarify: The late/* branch that I was referring to in my email
would just then contain the ISI patches, the rest would be in the
above branch.


-Olof
