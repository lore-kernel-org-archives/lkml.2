Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab1EYH3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 03:29:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62096 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab1EYH3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 03:29:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v5] uio/pdrv_genirq: Add OF support
Date: Wed, 25 May 2011 09:28:52 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Thomas De Schampheleire <patrickdepinguin+devicetree@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Greg KH <gregkh@suse.de>,
        John Williams <john.williams@petalogix.com>,
        linux-kernel@vger.kernel.org
References: <1304577644-4024-1-git-send-email-monstr@monstr.eu> <20110524162452.GA22936@pengutronix.de> <BANLkTinOe5nDB27JKPTNpNyEgKgM0qS=rA@mail.gmail.com>
In-Reply-To: <BANLkTinOe5nDB27JKPTNpNyEgKgM0qS=rA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105250928.52674.arnd@arndb.de>
X-Provags-ID: V02:K0:A0XvMi9UAO0upKwpDrfRI6iU4ouQ/+GqSHQ4Fv8szn+
 EDlfcYNI6H6I80g2wdaQHY4dnu6DdrSbYMkoFQdfPw9Xfsle+D
 hHeNb9M6X+Q5nIh/+N8xPJsQHxQkL8dPSx3TIaNFN91+HE6JNY
 ZITXkM/3MOBGcvDL+BR+k88dLowPEymjDk+zLPiRScT+1i/OR/
 b3G5UrgfiSRjltXKxJNVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 May 2011 09:27:57 Thomas De Schampheleire wrote:
> On Tue, May 24, 2011 at 6:24 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> I agree. After reading the entire thread a second time, I found the
> answer: current 'workaround' is to let users modify the generic
> driver's match table, while the real fix is to add runtime adding of
> compatible strings to platform devices.
> 
> However, the latter functionality is not yet present, right?

That is correct, yes.

	Arnd
