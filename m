Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103Ab1JNO6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:58:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:40758 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891Ab1JNO6j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:58:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=JgTviIHNW8u06/YvBPCRaZSiMito9JcFa7iFzBrZaczqjQD9vgC7Hr1rYDzW3H83Y
	LProl6GP7lmYeBGYx7ouA==
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1110141559220.14768@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1110140955030.2036-100000@iolanthe.rowland.org>
	<alpine.LNX.2.00.1110141559220.14768@pobox.suse.cz>
Date: Fri, 14 Oct 2011 07:58:37 -0700
X-Google-Sender-Auth: jRz3g4dQjzw4x4ZTwAr9Lwn8dqg
Message-ID: <CANLzEksars=PfOdx6Uxu-FbmxuXK0DMZoGW0HWbpogQ11YAA1Q@mail.gmail.com>
Subject: Re: [PATCH] HID: usbhid: enable remote wakeup for mice
From: Benson Leung <bleung@chromium.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the prompt response.

My initial reasoning was to set as default the wakeup behavior so a
mouse button press would wake the system. I am well aware that most if
not all mice don't support wake on move, but at least wake on button
press would have been more desirable than doing nothing.

Anyway, I'll solve this problem on my system by writing to wakeup
property on device attach. Consider my change abandoned.

Thanks,
Benson

On Fri, Oct 14, 2011 at 7:00 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Fri, 14 Oct 2011, Alan Stern wrote:
>
>> In addition, unlike keyboards, a lot of mice don't work very well when
>> they are suspended.  For example, many won't wake up when they are
>> moved (especially optical mice) and some don't even wake up when a
>> button is pressed.
>
> To stress it even more, I have tried with various types and brands of
> optical mouse, and I haven't encountered a single one that would wake up
> when moved.
>
>> This patch definitely should not be merged.
>
> I am not planning to do that.
>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
>



-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
