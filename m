Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab1HVGSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 02:18:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63498 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab1HVGSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 02:18:42 -0400
Message-ID: <4E51F4B8.6000104@mihu.de>
Date: Mon, 22 Aug 2011 08:18:32 +0200
From: Michael Hunold <michael@mihu.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] [media] saa7146: Use current logging styles
References: <cover.1313966088.git.joe@perches.com> <cfcea15fc2bcd602d01444afb5d09bdfdfa133f7.1313966089.git.joe@perches.com>
In-Reply-To: <cfcea15fc2bcd602d01444afb5d09bdfdfa133f7.1313966089.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:4CC7QpxSKlA5IieAi9LvjtOJUFqeb+4qB1Mm5PWUFIK
 BcF+trGvMmFHB5hK/B/5vmf1BwubE/dq5EsW/nv0xVbxuOt/bG
 5DhxYHVv8RD2HPEoAiliREqR6uYxSBJQdxcEqQVIkEEi03M+Xd
 RHAVe2dHpVDAdCHBFN+nCvOz/UvYhdLeX+qnb+529WRIsw37X2
 JWbyLEG5raKGX8NptcEuA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joe,

thanks for your effort. The patchset looks fine.

on 08/22/2011 12:56 AM Joe Perches said the following:
> Standardize the mechanisms to emit logging messages.

>  drivers/media/common/saa7146_core.c  |   74 ++++++++-------
>  drivers/media/common/saa7146_fops.c  |  118 +++++++++++++-----------
>  drivers/media/common/saa7146_hlp.c   |   14 ++-
>  drivers/media/common/saa7146_i2c.c   |   60 ++++++------
>  drivers/media/common/saa7146_vbi.c   |   48 +++++-----
>  drivers/media/common/saa7146_video.c |  171 ++++++++++++++++++----------------
>  drivers/media/video/hexium_gemini.c  |   42 +++++----
>  drivers/media/video/hexium_orion.c   |   38 ++++----
>  drivers/media/video/mxb.c            |   80 +++++++++-------
>  include/media/saa7146.h              |   36 +++++---
>  drivers/media/dvb/ttpci/av7110_v4l.c |   32 ++++---
>  drivers/media/dvb/ttpci/budget-av.c  |   42 ++++----

Acked-by: Michael Hunold <michael@mihu.de>

CU
Michael.
