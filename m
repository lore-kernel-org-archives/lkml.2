Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab0KSDc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 22:32:56 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:52012 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab0KSDcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 22:32:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OCz0NKzXDrDuq/sxxdy10MbOoBuiFtaIJGjH3qP1tW6MIkEY/t+Tg1Bw74JGZlWw3z
         rEJ/GFkYEnqfColOzBJkuMvNfiLc4Q5QLUjGSv+Wpr/PrsxOUHdI/hBhkjucPAhVOevf
         riBfUCIQ0+QKjHqWmyCMyXlMNtlShwgP18PC4=
Message-ID: <4CE5EFE0.8050604@gmail.com>
Date: Thu, 18 Nov 2010 19:32:48 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #19392] WARNING: at drivers/net/wireless/ath/ath5k/base.c:3475
 ath5k_bss_info_changed+0x44/0x168 [ath5k]()
References: <tTUH_XeInOH.A.dMF.c3b5MB@chimera> <t78YtCSuOqN.A.IiH.F5b5MB@chimera>
In-Reply-To: <t78YtCSuOqN.A.IiH.F5b5MB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 03:53 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.35 and 2.6.36.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.35 and 2.6.36.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=19392
> Subject		: WARNING: at drivers/net/wireless/ath/ath5k/base.c:3475 ath5k_bss_info_changed+0x44/0x168 [ath5k]()
> Submitter	: Justin Mattock<justinmattock@gmail.com>
> Date		: 2010-09-28 22:30 (52 days old)
> Message-ID	:<AANLkTim5WCGKPvEkOkO_YnMF9pg8mvLfQoFBNUFpfa_k@mail.gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=128571307018635&w=2
>
>
>


yep still there..

Justin P. Mattock
