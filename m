Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760461Ab2CTPLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 11:11:19 -0400
Received: from [89.21.227.130] ([89.21.227.130]:52005 "EHLO
	mail.epsilon.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754896Ab2CTPLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 11:11:17 -0400
Message-ID: <4F689E11.5090202@itdev.co.uk>
Date: Tue, 20 Mar 2012 08:11:13 -0700
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.input
To: Daniel Kurtz <djkurtz@chromium.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 11/20] Input: atmel_mxt_ts - refactor mxt_object_show
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org> <1331640263-18935-12-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1331640263-18935-12-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Kurtz wrote:
> Read each object with a single i2c transaction instead of byte-by-byte.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>

Acked-by: Nick Dyer <nick.dyer@itdev.co.uk>

-- 
Nick Dyer
Software Engineer, ITDev Ltd
Hardware and Software Development Consultancy
Website: http://www.itdev.co.uk
