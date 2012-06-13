Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab2FMIDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:03:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48495 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab2FMIC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:02:57 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:8656:0:788f:2f4:37fe:3171]
In-Reply-To: <20120613093744.Horde.0yc-Slm5A05P2ENIeQK2pwA@mail.selhorst.net>
References: <1339505034-6400-1-git-send-email-peter.huewe@infineon.com>
	<20120613093744.Horde.0yc-Slm5A05P2ENIeQK2pwA@mail.selhorst.net>
Date: Wed, 13 Jun 2012 01:02:55 -0700
Message-ID: <CAOesGMh6wkHk6mwJ29RJ-wnc0uUd5SVMqgboG590CTrYzWfJ_w@mail.gmail.com>
Subject: Re: [PATCH 1/2] char/tpm: Add new driver for Infineon I2C TIS TPM
From: Olof Johansson <olof@lixom.net>
To: Marcel Selhorst <tpmdd@selhorst.net>
Cc: Peter Huewe <peter.huewe@infineon.com>, srajiv@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Luigi Semenzato <semenzato@google.com>, andi.shyti@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel,

On Wed, Jun 13, 2012 at 12:37 AM, Marcel Selhorst <tpmdd@selhorst.net> wrote:
>
> Signed-off-by: Marcel Selhorst <tpmdd@selhorst.net>

Signed-off-by usually means "I touched this patch", as in applied it,
or forwarded it (or modified and forwarded it). See
Documentation/SubmittingPatches for full explanation. Do you mean
Acked-by or Reviewed-by here instead?

Who picks up this patch and feeds it upstream for linux-next and 3.6? Rajiv?


-Olof
