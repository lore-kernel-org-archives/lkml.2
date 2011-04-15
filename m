Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab1DONle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 09:41:34 -0400
Received: from mail.tricorecenter.de ([217.6.246.34]:39434 "EHLO
	root.phytec.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800Ab1DONld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 09:41:33 -0400
Subject: Re: [PATCH] leds: leds-pca9532 add support pca9530, pca9531 and
 pca9533
From: Jan Weitzel <J.Weitzel@phytec.de>
Reply-To: J.Weitzel@phytec.de
To: riku.voipio@iki.fi, rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1301992043-9552-1-git-send-email-j.weitzel@phytec.de>
References: <1301992043-9552-1-git-send-email-j.weitzel@phytec.de>
Organization: PHYTEC Messtechnik GmbH
Date: Fri, 15 Apr 2011 15:41:31 +0200
Message-ID: <1302874891.7246.15.camel@lws-weitzel>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-MIMETrack: Itemize by SMTP Server on Idefix/Phytec(Release 8.5.2 HF194|November 09, 2010) at
 15.04.2011 15:41:31,
	Serialize by Router on Idefix/Phytec(Release 8.5.2 HF194|November 09, 2010) at
 15.04.2011 15:41:32,
	Serialize complete at 15.04.2011 15:41:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 05.04.2011, 10:27 +0200 schrieb Jan Weitzel:
> Adding chipinfo to use driver with pca953x family
> Rename driver to pca953x, but left files and platformflags named pca9532
> 
> Tested with pca9530 and pca9533
> 
> Tested-by: Juergen Kilb <j.kilb@phytec.de>
> Signed-off-by: Jan Weitzel <j.weitzel@phytec.de>
> ---
>  drivers/leds/leds-pca9532.c |   80 ++++++++++++++++++++++++++++++++-----------

Is there any rework needed? 

Regards, Jan

