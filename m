Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab0H2XwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 19:52:18 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:62723 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab0H2XwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 19:52:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nx/JqIEr4HMHRDXezH/uleCiYKxTVRtfhHwzJZWPjtJsIzJdcDiAs0OPO5JgI3CTAw
         uJXu539UMuIBD0uYMKKDh/9H9Wp8AuzuJo+GSlrQHAyr0lXCv4rJRHIc8Wqoj7HCuoEQ
         z6sY02iQoLfte53BB5fPK59NfKcdDxBsTaihI=
Message-ID: <4C7AF2C4.9040507@gmail.com>
Date: Sun, 29 Aug 2010 16:52:36 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Pauli Nieminen <suokkos@gmail.com>
Subject: Re: [Bug #16337] general protection fault: 0000 [#1] SMP
References: <c1_O4wHrlB.A.63.mbueMB@chimera> <ByD_7B96czP.A.3DD.5fueMB@chimera>
In-Reply-To: <ByD_7B96czP.A.3DD.5fueMB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2010 04:13 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.34 and 2.6.35.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16337
> Subject		: general protection fault: 0000 [#1] SMP
> Submitter	: Justin P. Mattock<justinmattock@gmail.com>
> Date		: 2010-07-03 22:59 (58 days old)
> Message-ID	:<<4C2FC0E3.6050101@gmail.com>>
> References	: http://marc.info/?l=linux-kernel&m=127819798215589&w=2
>
>
>


only have seen this once..on the other hand (If im correct)maciej or 
pauli where able to reproduce this.. I say leave open then go from there.

Justin P. Mattock
