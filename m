Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab1J1TrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 15:47:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35691 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab1J1TrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 15:47:19 -0400
MIME-Version: 1.0
In-Reply-To: <1319662641-28416-1-git-send-email-marek.belisko@open-nandra.com>
References: <1319662641-28416-1-git-send-email-marek.belisko@open-nandra.com>
Date: Fri, 28 Oct 2011 21:47:18 +0200
Message-ID: <CACRpkdZfw1qEY83vNc2yDQLHezuGa58O+E011+oi29KKQRM7bA@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinmux: Remove double pin validity check.
From: Linus Walleij <linus.walleij@linaro.org>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: swarren@nvidia.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 10:57 PM, Marek Belisko
<marek.belisko@open-nandra.com> wrote:

> Function pin_is_valid just call pin_desc_get which is in pin_request
> call some line below. Remove pin_is_valid() check.
>
> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>

So it is. Applied patch with Stephen's ACK.
Thanks Marek!

Linus Walleij
