Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab1ISUM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 16:12:29 -0400
Received: from mailout02.t-online.de ([194.25.134.17]:60806 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab1ISUM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 16:12:27 -0400
Message-ID: <4E77A221.1060909@t-online.de>
Date: Mon, 19 Sep 2011 22:12:17 +0200
From: =?ISO-8859-15?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Nestor Lopez Casado <nlopezcasad@logitech.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtitmuss@logitech.com, ogay@logitech.com, jzanone@logitech.com
Subject: Re: [PATCH v5 1/1] HID: Add full support for Logitech Unifying receivers
References: <1316018905-4175-1-git-send-email-nlopezcasad@logitech.com>
In-Reply-To: <1316018905-4175-1-git-send-email-nlopezcasad@logitech.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-ID: VgH-9vZbYhP7y20K1VdhvQaU9ERFoKYW8W7TKHoNiNqQ4vygEsgtYCiKYcKElfSgxp
X-TOI-MSGID: 21eee661-7053-46e3-a4c6-a7478a08067c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.09.2011 18:48, schrieb Nestor Lopez Casado:
> From: Nestor Lopez Casado<nlopezcasad@logitech.com>
>
> With this driver, all the devices paired to a single Unifying
> receiver are exposed to user processes in separated /input/dev
> nodes.

But there's still no way to pair devices with an Unifying receiver under 
Linux, right? It would be nice to have a simple userspace tool for that, 
too.

-- 
Regards,
Richard Schütz
