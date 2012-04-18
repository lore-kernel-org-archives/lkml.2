Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab2DRLm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 07:42:28 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47757 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab2DRLm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 07:42:27 -0400
MIME-Version: 1.0
In-Reply-To: <1334696661-3569-1-git-send-email-seth.heasley@intel.com>
References: <1334696661-3569-1-git-send-email-seth.heasley@intel.com>
Date: Wed, 18 Apr 2012 13:42:26 +0200
Message-ID: <CACRpkdam72rzUNWabCOG3GoCXiYqwv=EYHniUmSeZpdqyOV-ng@mail.gmail.com>
Subject: Re: [PATCH 2/3] gpio-sch: Add Intel Centerton DeviceID for GPIO
From: Linus Walleij <linus.walleij@linaro.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org,
        James Ralston <james.d.ralston@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 11:04 PM, Seth Heasley <seth.heasley@intel.com> wrote:

> This patch adds the Intel Centerton processor DeviceID for GPIO. The DeviceID is defined in include/linux/pci_ids.h
>
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>

That's straight-forward :)

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
