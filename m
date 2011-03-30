Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab1C3LrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 07:47:06 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46099 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350Ab1C3LrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 07:47:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=VyG3oVsGl8aVeU8KDWOYEa4eEpz/7P1QTpE1CNfM6HXFLwr4sAhub7RCvYNYG/DnFQ
         7Pa32iTE4fjl0bc5/pd712/9Wqd7Sy8T46NzE4WbM1JM8TfW1XIGFiQRuupo8NBc2Ro0
         cYce94LCa4BxQQxswVUINakCpRS+1Zat/dU4U=
MIME-Version: 1.0
In-Reply-To: <1301446249-13646-2-git-send-email-cheiny@synaptics.com>
References: <1301446249-13646-1-git-send-email-cheiny@synaptics.com> <1301446249-13646-2-git-send-email-cheiny@synaptics.com>
From: Joerie de Gram <j.de.gram@gmail.com>
Date: Wed, 30 Mar 2011 13:46:43 +0200
Message-ID: <AANLkTi=jFSrbRaAN57JxRfTyVZTCtB+3jOGPL4yLs=_w@mail.gmail.com>
Subject: Re: [PATCH 1/3] input/touchscreen: Synaptics RMI4 Touchscreen Driver
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> +#include "rmi.h"

This header is missing.

Joerie
