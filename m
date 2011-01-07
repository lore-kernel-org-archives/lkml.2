Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1AGW0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:26:52 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64768 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab1AGW0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:26:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xf5LcroV1yrpFDEALckXtpbkci/Fzi6ZwUG9iuGxwW7OQWsRP+mZI3W6VIAOQZN+Bh
         Xh4Lv16n2KOcQ0ISOLm6Zev4zgxeaXYphdpZRNU9jd3ROsVqjbBbTtiCG6eX9jNJbC8b
         qCBhErAm+QP5ueOu/EMZc+yo1ARScDI792JUw=
Message-ID: <4D279325.3040205@gmail.com>
Date: Sat, 08 Jan 2011 01:26:45 +0300
From: Nikolai Kondrashov <spbnick@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Documentation: Add evdev type and code definitions
References: <1294435695-16750-1-git-send-email-chase.douglas@canonical.com> <4D278E6B.7020002@gmail.com> <4D279075.4080503@canonical.com>
In-Reply-To: <4D279075.4080503@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2011 01:15 AM, Chase Douglas wrote:
> Hmm.. That seems incorrect to me. Why wouldn't it follow the behavior
> outlined above?
Because the tablet doesn't report when the tool enters/leaves the proximity.
It just starts/stops sending the coordinates.

A leave timer could be used, though. Maybe we could ignore the case when the
mouse is laying still on the tablet or the pen is held very steadily in
place and just tell that tool left the surface.

Maybe it will be beneficial to have it synthesised after all, as it would
probably ease the integration with xf86-input-wacom and will keep the evdev
protocol more consistent.

Sincerely,
Nick
