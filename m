Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373Ab2EYTOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 15:14:43 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:64617 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932226Ab2EYTOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 15:14:42 -0400
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 May 2012 15:14:42 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIBAG6Zu08Y9geI/2dsb2JhbAANN4UtqxuGZgEBAQEDI1UBEAsYAgIFFgsCAgkDAgECAUUGDQEHAQGvGJJ7gSaOCoEUA6gQ
X-IronPort-AV: E=Sophos;i="4.75,637,1330923600"; 
   d="scan'208";a="182527890"
Message-ID: <4FBFD7DC.9070604@teksavvy.com>
Date: Fri, 25 May 2012 15:05:00 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 3.5-rc0
References: <20120524083216.GD10562@core.coreip.homeip.net> <CA+55aFxw0HRpizzJZxhhA2oqPpzg4DPUvH2r7YoYfctXS6K=WQ@mail.gmail.com> <20120524180154.GA15036@core.coreip.homeip.net> <CA+55aFx0ww=BtYAj9WEbqMT2R30ZZpjd014cYCpC=b+HRtUf_A@mail.gmail.com> <20120524195851.GA15306@core.coreip.homeip.net>
In-Reply-To: <20120524195851.GA15306@core.coreip.homeip.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-05-24 03:58 PM, Dmitry Torokhov wrote:
>
> On  the topic of naming - nobody cares what input devices are called as
> long as they are unique. Userspace does not work with input devices
> directly (there is no API), they are working with iterfaces (such as
> evdev) that have their own interfaces and names.

I regularly work with input devices from userspace,
using the "lsinput" "xinput", and "input-kbd" commands (among others)
from various shell scripts.

So I guess that makes me one of those anonymous "nobody" types
who "don't care" about it.

Usually the device naming I see there makes some kind of sense.

