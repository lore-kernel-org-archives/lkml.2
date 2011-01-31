Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab1AaKUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:20:43 -0500
Received: from mailout06.t-online.de ([194.25.134.19]:53225 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab1AaKUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:20:41 -0500
Message-ID: <4D468CF0.9040103@t-online.de>
Date: Mon, 31 Jan 2011 11:20:32 +0100
From: =?UTF-8?B?UmljaGFyZCBTY2jDvHR6?= <r.schtz@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101230 Lanikai/3.1.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        colin.king@canonical.com
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus
 laptops)
References: <556624.21214.qm@web28409.mail.ukl.yahoo.com> <201101302348.40509.rjw@sisk.pl> <4D467882.9060304@pardus.org.tr> <201101311050.49722.rjw@sisk.pl>
In-Reply-To: <201101311050.49722.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ID: ESd+--ZdQhQiv+9aDJDlvwpe6dbCOwjLtPlCTpBVib7P1IWx0-diL1yxOKolcD4ZGP
X-TOI-MSGID: 91329112-41de-47a3-998e-75b2e885447f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I'll compile a kernel with CONFIG_NO_HZ to see what happens but how do I
>> disable cpuidle during boot? I've checked the kernel-parameters.txt but
>> there's no cpuidle related boot parameter there.
>
> Booting with intel_idle.max_cstate=0 should do the trick.

intel_idle.max_cstate=0 causes a fallback to the acpi_idle driver. So it 
does not disable the C-states directly.

-- 
Regards,
Richard Schütz
