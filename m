Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab2EEKhR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 06:37:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60170 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab2EEKhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 06:37:14 -0400
Message-ID: <4FA502D6.3000500@gmail.com>
Date: Sat, 05 May 2012 13:37:10 +0300
From: Adrian Fita <adrian.fita@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: Ralf Jung <post@ralfj.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jonathan Nieder <jrnieder@gmail.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Len Brown <lenb@kernel.org>, Paolo Scarabelli <paolo@msw.it>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] battery: only refresh the sysfs files when pertinant
 information changes
References: <20120503124708.GA18622@srcf.ucam.org> <1336052907-15084-1-git-send-email-apw@canonical.com> <201205041529.07142.post@ralfj.de>
In-Reply-To: <201205041529.07142.post@ralfj.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/12 16:29, Ralf Jung wrote:
> Hi,
> 
> I applied this to 3.4-rc5, and it fixes the issue. Thanks a lot :)

[...]

Hi. I got to test the patch today against the 3.2.16 stable kernel and I
can confirm that it solved the issue. I no longer see "remove"/"add"
events when running "udevadm monitor --property"; I only see "change"
events.

Thanks alot!

Do you know if this patch will be backported to the 3.2 kernel, which
will be the stable kernel for many linux distributions for many years (I
know that the next Debian Stable/wheezy will be using the 3.2 kernel)?

PS: you misspelled "pertinent" in the patch's title. You wrote "pertinant".

Regards,
-- 
Fita Adrian
