Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab1CYViO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:38:14 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65501 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab1CYViM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:38:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=DmMCKKUBnJMTwBHcTUQbZU4xAHZuPuG4+LuNIFb61ssYPIXefwYg9uDuejjiC2apnz
         p/otV2rr2PlCwMhMfZjIc5Q75u/OPRaFWHxs3IYXmHDdbrTSR+ZzbqzL2nKoJY5/WNZ2
         bxvPLPybH1JgNASR3nFG6cPwdpK5h3xYTmUU8=
MIME-Version: 1.0
In-Reply-To: <1301073283-30821-5-git-send-email-jamie@jamieiles.com>
References: <1301073283-30821-1-git-send-email-jamie@jamieiles.com> <1301073283-30821-5-git-send-email-jamie@jamieiles.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 25 Mar 2011 17:37:52 -0400
X-Google-Sender-Auth: be2OD5JdLEiQHH2jsoGAAuxYmMM
Message-ID: <AANLkTimS9E35mHaXb0h=v7EMoPDxsfm78fq3XN+S8m9G@mail.gmail.com>
Subject: Re: [RFC PATCHv3 4/4] Blackfin: add the OTP device as a platform device
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 13:14, Jamie Iles wrote:
> Register the OTP as a platform device so that we can use the generic
> OTP subsystem.

i would move this to patch 3/4 so that the boards are updated before
the driver is converted to a platform_driver

otherwise, this patch looks good to me (i'll hold off on actually
testing things until common code has settled a bit)
-mike
