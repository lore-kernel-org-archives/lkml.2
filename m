Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab2FRPJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:09:57 -0400
Received: from [89.21.227.130] ([89.21.227.130]:46536 "EHLO
	mail.epsilon.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751294Ab2FRPJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:09:55 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jun 2012 11:09:55 EDT
Message-ID: <4FDF44C1.70500@itdev.co.uk>
Date: Mon, 18 Jun 2012 16:09:53 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, linux-input@vger.kernel.org,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/22 v4] Input: atmel_mxt_ts - parse T6 reports
References: <1339992522-22073-1-git-send-email-djkurtz@chromium.org> <1339992522-22073-23-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1339992522-22073-23-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Kurtz wrote:
> The normal messages sent after boot or NVRAM update are T6 reports,
> containing a status, and the config memory checksum.  Parse them and dump
> a useful info message.

This can cause a lot of dmesg output - for instance you get 2 messages per
calibration, and the chip can trigger them itself if noise suppression or
anti-touch calibration are enabled. So perhaps dev_dbg()?

-- 
Nick Dyer
Software Engineer, ITDev Ltd
