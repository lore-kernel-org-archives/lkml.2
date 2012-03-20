Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306Ab2CTPHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 11:07:51 -0400
Received: from [89.21.227.130] ([89.21.227.130]:51990 "EHLO
	mail.epsilon.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754206Ab2CTPHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 11:07:49 -0400
Message-ID: <4F689D41.9080507@itdev.co.uk>
Date: Tue, 20 Mar 2012 08:07:45 -0700
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
        "Tiwari, Atul" <Atul.Tiwari@atmel.com>,
        "Bowens, Alan" <Alan.Bowens@atmel.com>
Subject: Re: [PATCH 09/20] Input: atmel_mxt_ts - do not read extra (checksum)
 byte
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org> <1331640263-18935-10-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1331640263-18935-10-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Kurtz wrote:
> It isn't sent, nor checked anyway, so don't bother reading it.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>

This is fair enough, although IMO the checksum should be checked.

-- 
Nick Dyer
Software Engineer, ITDev Ltd
Hardware and Software Development Consultancy
Website: http://www.itdev.co.uk
