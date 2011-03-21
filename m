Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab1CUIQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 04:16:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52638 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab1CUIQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 04:16:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=hvXQoOEX9RMGVsHVk4I5djoKXkAHQtfbqPjudxuUsFfJVw7zggOKuDqbM+zg7fd8XT
         arjbXRB+04kA/Wi6e2bcnUuewaWc1+LbKe6oPEWMBtVg6+02HTQC+GnZ0JDD9QiAualM
         lgUwnFHdZk9ZSePt37WIGlqBlcvjcVN5ULsL8=
MIME-Version: 1.0
In-Reply-To: <1292321383-30200-1-git-send-email-carlos.chinea@nokia.com>
References: <1292321383-30200-1-git-send-email-carlos.chinea@nokia.com>
Date: Mon, 21 Mar 2011 09:16:39 +0100
X-Google-Sender-Auth: paQ2cklNwdMVMyywMbNjgPDxoaQ
Message-ID: <AANLkTimTfOyhDR6BsHD_1VvzOPGbYqo6L784wPkQMi_8@mail.gmail.com>
Subject: Re: [RFC PATCHv4 0/7] HSI framework and drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        pawel.szyszuk@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/14 Carlos Chinea <carlos.chinea@nokia.com>:

> Here you have the fourth round of the HSI framework patches.

I'd like to notify that this out-of-tree framework is also in use for
the ST-Ericsson
Ux500s, and we've had great success with it. You can add my:

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Possibly some ST-Ericsson people can add Tested-by tags as well.

We will integrate Ux500 support whenever it's suitable, either after the merge
or as add-on patches for Carlos patch series. (If Carlos would like to keep
them in his series.)

Yours,
Linus Walleij
