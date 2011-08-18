Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab1HRCvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 22:51:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37152 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab1HRCvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 22:51:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=QPkTST0p6TBzs8OFUdLZN7kNenX5aqNNVQq6lkOH0ZsAcQZOdurRGS60zi3iotmNf
	oZdc8cugDuPRayC8ngSbA==
MIME-Version: 1.0
In-Reply-To: <1313632629-23603-5-git-send-email-jj_ding@emc.com.tw>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-5-git-send-email-jj_ding@emc.com.tw>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 18 Aug 2011 10:50:47 +0800
X-Google-Sender-Auth: DHM1pHR131VukwM0CIN4QC19rnY
Message-ID: <CAGS+omBwPxzCpYPL0X9SOGoKf+cjMKtmvAAhcrDwVTCw2vh-WA@mail.gmail.com>
Subject: Re: [PATCH 4/6] Input: elantech - work around EC buffer
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
> With some EC chips, when we resync due to bad packets, those bad bytes would
> still remain in EC's buffer area. That makes us always get bad data back,
> no matter what.
>
> So shift packet for 1 byte when encounter bad packet, until we get rid of those
> bytes.
>
> Signed-off-by: JJ Ding <jj_ding@emc.com.tw>

Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>
