Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760489Ab2CTPFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 11:05:48 -0400
Received: from [89.21.227.130] ([89.21.227.130]:33620 "EHLO
	mail.epsilon.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753526Ab2CTPFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 11:05:46 -0400
Message-ID: <4F689CC6.7020706@itdev.co.uk>
Date: Tue, 20 Mar 2012 08:05:42 -0700
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>,
        "Bowens, Alan" <Alan.Bowens@atmel.com>,
        "Tiwari, Atul" <Atul.Tiwari@atmel.com>
Subject: Re: [PATCH 08/20] Input: atmel_mxt_ts - store actual size and instance
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org> <1331640263-18935-9-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1331640263-18935-9-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Kurtz wrote:
> These two object table entry fields are reported 1 less than their value.
> So add 1 once, when building the object table, instead of every time
> these fields are accessed.

As per the patch I sent you which does the same thing, you will need to
change the size and instances from u8 to u16.

see
https://github.com/atmel-maxtouch/linux/commit/2643b0a753de5fd607ea6e131aacf5bd69dd8e27

-- 
Nick Dyer
Software Engineer, ITDev Ltd
Hardware and Software Development Consultancy
Website: http://www.itdev.co.uk
