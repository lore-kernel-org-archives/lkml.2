Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab1HWJDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 05:03:41 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:58403 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755079Ab1HWJDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 05:03:37 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC PATCH v2] Resurrect Intel740 driver: i740fb
Date: Tue, 23 Aug 2011 11:03:30 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
References: <201108212242.12717.linux@rainbow-software.org> <20110821233648.6d120143@lxorguk.ukuu.org.uk>
In-Reply-To: <20110821233648.6d120143@lxorguk.ukuu.org.uk>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201108231103.30591.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 August 2011, Alan Cox wrote:
> > - 24bpp modes still don't work in fbtest but it looks like fbtest bug!
> >
> > Is there any better way to test fb drivers than fbtest?
>
> X11 fbdev driver ?

Thanks, completely forgot about that. It works fine even in 24bpp.

> Alan


-- 
Ondrej Zary
