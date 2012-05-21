Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab2EUOJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:09:06 -0400
Received: from stats.peacock.arvixe.com ([174.122.104.67]:48070 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757420Ab2EUOJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:09:04 -0400
Message-ID: <5dc3b5b61e2776c46cbd97c82f88c870.squirrel@webmail.firszt.eu>
In-Reply-To: <alpine.DEB.2.00.1205191905430.24674@chino.kir.corp.google.com>
References: <1336674232-5410-1-git-send-email-przemo@firszt.eu>
    <alpine.LNX.2.00.1205111448350.17928@pobox.suse.cz>
    <alpine.DEB.2.00.1205191905430.24674@chino.kir.corp.google.com>
Date: Mon, 21 May 2012 15:08:56 +0100
Subject: Re: [PATCH] HID: wacom: Add LED selector control for Wacom Intuos4
 WL
From: "Przemo Firszt" <przemo@firszt.eu>
To: "David Rientjes" <rientjes@google.com>
Cc: "Jiri Kosina" <jkosina@suse.cz>, "Przemo Firszt" <przemo@firszt.eu>,
        pinglinux@gmail.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linuxwacom-devel@lists.sourceforge.net
Reply-To: przemo@firszt.eu
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-2
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - peacock.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dnia 20 Maja 2012, 3:11 am, N, David Rientjes napisa³(a):
> On Fri, 11 May 2012, Jiri Kosina wrote:
>
>> > Add sysfs attribute to control LED selector on Wacom Intuos4.
>>
>> Applied, thanks.
>>
>
> This results in a build failure if you've enabled CONFIG_HID_WACOM without
> CONFIG_NEW_LEDS, which is required for CONFIG_LEDS_CLASS.
>
[..]
Thanks for catching that!
-- 
Regards,
Przemo Firszt

