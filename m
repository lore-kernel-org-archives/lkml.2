Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760580Ab2CTPam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 11:30:42 -0400
Received: from [89.21.227.130] ([89.21.227.130]:42147 "EHLO
	mail.epsilon.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755008Ab2CTPal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 11:30:41 -0400
Message-ID: <4F68A29A.7060700@itdev.co.uk>
Date: Tue, 20 Mar 2012 08:30:34 -0700
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
Subject: Re: [PATCH 17/20] Input: atmel_mxt_ts - use cached T9 reportid range
 in isr
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org> <1331640263-18935-18-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1331640263-18935-18-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Kurtz wrote:
> Streamline interrupt processing by caching the T9 reportid range when
> first initializing the object table.
> 
> Note: the cached T9 reportid's are initialized to 0, which is an invalid
> reportid.  Thus, the checks in the interrupt handler will always fail
> for devices that do not support the T9 object.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>

You need to support the case where there are multiple T9 instances.

-- 
Nick Dyer
Software Engineer, ITDev Ltd
Hardware and Software Development Consultancy
Website: http://www.itdev.co.uk
