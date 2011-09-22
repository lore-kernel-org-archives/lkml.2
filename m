Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab1IVVSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 17:18:12 -0400
Received: from mailout05.t-online.de ([194.25.134.82]:53105 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab1IVVSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 17:18:11 -0400
Message-ID: <4E7BA605.3020908@t-online.de>
Date: Thu, 22 Sep 2011 23:17:57 +0200
From: =?ISO-8859-1?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
CC: Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, rtitmuss@logitech.com, ogay@logitech.com,
        jzanone@logitech.com
Subject: Re: [PATCH v5 1/1] HID: Add full support for Logitech Unifying receivers
References: <1316018905-4175-1-git-send-email-nlopezcasad@logitech.com> <4E77A221.1060909@t-online.de> <CAN+gG=EcaMrz2w-cVL-cCwi2NNVJ-NXOpOQpbjyFdCwn5+Bn+w@mail.gmail.com>
In-Reply-To: <CAN+gG=EcaMrz2w-cVL-cCwi2NNVJ-NXOpOQpbjyFdCwn5+Bn+w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-ID: GEVgcmZ6ghbgMmVqrVltJB1Jkyc7fM633SxLdNVc87E25jTVTC5K1rGEAiO+1XGgyU
X-TOI-MSGID: a75902ad-39f4-4301-88c7-0e835d05537d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.09.2011 22:48, schrieb Benjamin Tissoires:
> Hi Richard,
>
> here, you'll find a small C program that allows you to do a pairing of
> a new device to a receiver.

Thanks.

Could you also add the possibility to remove a pairing? It would be nice 
if the program would print the product name of device detected during 
the pairing process, too.

I think the tool should be distributed somewhere officially. There are 
probably a lot of people, who would use the Unifying feature under 
Linux, but don't read the mailing lists.

-- 
Regards,
Richard Schütz
