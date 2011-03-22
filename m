Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab1CVJvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 05:51:46 -0400
Received: from smtp.nokia.com ([147.243.128.24]:43651 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab1CVJvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 05:51:42 -0400
Subject: Re: [RFC PATCHv4 0/7] HSI framework and drivers
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        pawel.szyszuk@stericsson.com
In-Reply-To: <AANLkTimTfOyhDR6BsHD_1VvzOPGbYqo6L784wPkQMi_8@mail.gmail.com>
References: <1292321383-30200-1-git-send-email-carlos.chinea@nokia.com>
	 <AANLkTimTfOyhDR6BsHD_1VvzOPGbYqo6L784wPkQMi_8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 11:50:04 +0200
Message-ID: <1300787404.8008.116.camel@groo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2011-03-21 at 09:16 +0100, ext Linus Walleij wrote:
> 2010/12/14 Carlos Chinea <carlos.chinea@nokia.com>:
> 
> > Here you have the fourth round of the HSI framework patches.
> 
> I'd like to notify that this out-of-tree framework is also in use for
> the ST-Ericsson
> Ux500s, and we've had great success with it. You can add my:
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 

Thanks I will add the Ack to the next round of patches.

We are currently working on the hsi_char module. Apart from addressing
the comments from Alan,  we are planning to drop also the non-blocking
support from it. The current version is not fully honoring the
non-blocking behavior.

> Possibly some ST-Ericsson people can add Tested-by tags as well.
> 
> We will integrate Ux500 support whenever it's suitable, either after the merge
> or as add-on patches for Carlos patch series. (If Carlos would like to keep
> them in his series.)
> 

Either way is fine, for me. Could you send the patches for review ?

Br,
Carlos
-- 
Carlos Chinea <carlos.chinea@nokia.com>

