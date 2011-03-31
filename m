Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343Ab1CaP3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:29:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52663 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab1CaP27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:28:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [RFC PATCH 00/21] IIO: Channel registration rework, buffer chardev combining and rewrite of triggers as 'virtual' irq_chips.
Date: Thu, 31 Mar 2011 17:28:49 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.5.1; x86_64; ; )
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
In-Reply-To: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103311728.50077.arnd@arndb.de>
X-Provags-ID: V02:K0:h1l/Y2GxpvGJmeaoNwsRGw3f2OmSKmiEm/i99uQ4uIh
 hVhT+9WkpajWyKHlwgEbsJChkFP5/3qxEyAAuebl8aS/JFVVhN
 Uc4l+pJaYGTF/kmAyJxZq054zCkvY9zK332yOUQqd5UZIVWSzS
 gBB/FVt6+Qrgeh0bCiNPpYfF5MKM4SNuOtmtSEvUPuDIClaPeY
 iQdq9F+qc3LoYJHwHCC4g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 March 2011, Jonathan Cameron wrote:
> I'm afraid what in many ways makes sense as three separate
> series have gotten rather intertwined.  I can probably unpick
> them but it will involve a lot of intermediate code in
> lis3l02dq (which is our fiddly example for this set) that I'd
> rather avoid.  Hence lets have a guide to what various people
> might be interested in:

Hi Jonathan,

Great to see your progress here. Unfortunately I currently don't
have much time to look at the patches in the necessary depth,
since I'll be travelling for the next two weeks up till ELC
in San Francisco. I might find some time to look at the patches,
but don't promise anything now, so please remind me later
if you want specific feedback.

	Arnd
