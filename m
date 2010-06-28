Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab0F1UUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 16:20:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55305 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab0F1UUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 16:20:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ViI73hVENTzBvgmbzZ7rj41qjJOLv1E6+B+ZePrw30YAo0bIXn+GzKTustywlPkZgq
         NASRlXKr+foY5uBQihPzHTudCJdPqRo3UpZBNYncd0rUaXvmtgq1HsvXLEkjuGO2zvkH
         VNcjrjhGw+hNjMEEq4N8J09sNiBnANQWHSHeg=
MIME-Version: 1.0
In-Reply-To: <1277069076-30579-1-git-send-email-linus.walleij@stericsson.com>
References: <1277069076-30579-1-git-send-email-linus.walleij@stericsson.com>
Date: Mon, 28 Jun 2010 22:20:02 +0200
Message-ID: <AANLkTikbk4zoFQfunWz1yQ7d2tYhm4illg6CyeOnVkDk@mail.gmail.com>
Subject: Re: [PATCH 00/19] DMAENGINE: ste_dma40: bugfixes v2
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan, can these fixes go in now? I'd like to base
the new patches for channel control and PrimeCells on
top of these so it doesn't stack up...

Yours,
Linus Walleij
