Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab1HRCpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 22:45:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35472 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab1HRCo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 22:44:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=sXkJwx2S4O7m3Kiw7nsXKDyiH4nG/xAKl8Qb6nxT8rp/lm9ZnnrF4fwAu+ZEvQ2nc
	Vz0FlFJ44R6fAYENJWZxw==
MIME-Version: 1.0
In-Reply-To: <1313632629-23603-3-git-send-email-jj_ding@emc.com.tw>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-3-git-send-email-jj_ding@emc.com.tw>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 18 Aug 2011 10:44:35 +0800
X-Google-Sender-Auth: RIWSXN1ZNM1LOFPOksnTTuMy_Rk
Message-ID: <CAGS+omAroQyyYSReVvy401dcdbitQ-uror78bVZKAi2obLWKGQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] Input: elantech - use firmware provided x, y ranges
To: JJ Ding <jj_ding@emc.com.tw>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 9:57 AM, JJ Ding <jj_ding@emc.com.tw> wrote:
> With newer hardware, the touchpad provides range info.
> Let's use it.
>
> Signed-off-by: JJ Ding <jj_ding@emc.com.tw>

Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>
