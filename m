Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab0EGK4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 06:56:54 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:36575 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673Ab0EGK4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 06:56:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iGazL/cBjFpXEFRFk4x6qggS5vL8UAaGPVEFo0OMj1gNGddmh8X/R3EFfd+fIwk6s+
         P1kG6Oy5wW20Z4Kr0pPeNQdL7zMJsPI7VrrwKixhuyWvsIIZS0bKYf2hAcMQlFrZxHGY
         qEy1YHVkTgH3t9+MY4a3Fc6eRgLaR+usbK65s=
MIME-Version: 1.0
In-Reply-To: <1264620749-24527-4-git-send-email-adharmap@codeaurora.org>
References: <1264620749-24527-1-git-send-email-adharmap@codeaurora.org>
	 <1264620749-24527-4-git-send-email-adharmap@codeaurora.org>
Date: Fri, 7 May 2010 12:56:49 +0200
Message-ID: <h2z63386a3d1005070356r23cee2c7m5d0ac534ec0182d4@mail.gmail.com>
Subject: Re: [PATCH 3/5] gic: Add set_type callback
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: adharmap@codeaurora.org
Cc: linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Yinghai Lu <yinghai@kernel.org>, Tony Lindgren <tony@atomide.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Kalle Valo <kalle.valo@iki.fi>, Jean Pihet <jpihet@mvista.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Colin Tuckley <colin.tuckley@arm.com>,
       Philby John <pjohn@in.mvista.com>,
       Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
       Alessandro Rubini <rubini@unipv.it>,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>,
       Rabin VINCENT <rabin.vincent@stericsson.com>,
       Mian.Yousaf.Kaukab@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/27  <adharmap@codeaurora.org>:

> From: Abhijeet Dharmapurikar <adharmap@quicinc.com>
>
> Add gic_set_type callback to set an irq as level or edge triggered type

Abhijeet, will you pursue this patchset?

Else we will pick it up and propose our solution for the U8500 needs which
are similar.

Yours,
Linus Walleij
