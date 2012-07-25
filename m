Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab2GYPdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:33:00 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:34438 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab2GYPc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:32:58 -0400
MIME-Version: 1.0
In-Reply-To: <500FC428.8030305@samsung.com>
References: <CAD=FV=Wa1bCRvLNnFjhht6nvNorm3CRzX5zrn-YDA2Jec1K3Eg@mail.gmail.com>
	<1343149145-22927-1-git-send-email-dianders@chromium.org>
	<500FC428.8030305@samsung.com>
Date: Wed, 25 Jul 2012 08:32:57 -0700
X-Google-Sender-Auth: nbLCAn0JgXdt_dcRyTvmY2YQRYQ
Message-ID: <CAD=FV=V0Z=f+DNZKnaX9cJqS3MTmPdF8G3wmbYJYW34bUZqoXg@mail.gmail.com>
Subject: Re: [PATCH v3] mmc: dw_mmc: Disable low power mode if SDIO interrupts
 are used
From: Doug Anderson <dianders@chromium.org>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Will Newton <will.newton@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, linux-kernel@vger.kernel.org,
        Grant Grundler <grundler@chromium.org>,
        Olof Johansson <olofj@chromium.org>, shashidharh@vayavyalabs.com,
        ki0351.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 3:02 AM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> Just use the slot. slot is already assigned to mmc_priv(mmc)

Oops.  Now I feel sheepish.  Done.  :)
