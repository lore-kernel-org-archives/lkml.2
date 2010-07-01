Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab0GAMzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 08:55:50 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41725 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab0GAMzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 08:55:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gSgtOpsxAwseirP+0fIiJ914Dcv+86SdnTTvB+0uJtQNHqNVjeE7AmyxCOIo+QrxVs
         q70ZHF6Z7ElPE93+8S7TQhDufH0Ny8jJMT6b8sOYeNyLMrxyctCmpZNJi2T2hFHUXAVu
         WQqxqU/53xEd+O3FKLYhZVJdsd6EtoGl7Luzs=
MIME-Version: 1.0
In-Reply-To: <e5391de6858597bbfd43874aed124a73f74850b5.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
	<e5391de6858597bbfd43874aed124a73f74850b5.1277911346.git.siccegge@cs.fau.de>
Date: Thu, 1 Jul 2010 21:55:47 +0900
Message-ID: <AANLkTinZa7_TEjYFTu9V6obndpVvMmHppaOArM1AJg_t@mail.gmail.com>
Subject: Re: [PATCH 29/33] Removing dead SND_SOC_SMDK2443_WM9710
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jassi Brar <jassi.brar@samsung.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 1, 2010 at 1:03 AM, Christoph Egger <siccegge@cs.fau.de> wrote:
> SND_SOC_SMDK2443_WM9710 doesn't exist in Kconfig, therefore removing
> all references for it from the source code.
I'd rather have the code compiled unconditionally.
