Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab1BHIYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 03:24:20 -0500
Received: from mx4.orcon.net.nz ([219.88.242.54]:46960 "EHLO mx4.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab1BHIYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 03:24:19 -0500
Message-ID: <4D50FDA7.3050803@orcon.net.nz>
Date: Tue, 08 Feb 2011 21:24:07 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [Bug #25432] Alpha fails to build with gcc 4.4
References: <e9vOd5LzdBK.A.dyD.h6eSNB@chimera> <-tcJxClTQPH.A.TLF.d8eSNB@chimera>
In-Reply-To: <-tcJxClTQPH.A.TLF.d8eSNB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx4.orcon.net.nz on Tue, 08 Feb 2011 21:24:18 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Feb  8 21:24:18 2011
X-DSPAM-Confidence: 0.5641
X-DSPAM-Probability: 0.0138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/11 13:05, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> introduced between 2.6.36 and 2.6.37.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=25432
> Subject		: Alpha fails to build with gcc 4.4
> Submitter	: Ben Hutchings<ben@decadent.org.uk>
> Date		: 2010-12-22 01:55 (43 days old)

Fixed by commit e2609f6aa2dce5d960ea1fe32f57524c315dede5.

Cheers
Michael.
