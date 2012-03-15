Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344Ab2COKs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 06:48:57 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47841 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab2COKsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 06:48:54 -0400
Message-ID: <4F61C911.5010204@suse.cz>
Date: Thu, 15 Mar 2012 11:48:49 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120307 Thunderbird/11.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: stable-3.0: s390 build breakage [was: Linux 3.0.24]
References: <20120312203451.GA16773@kroah.com>
In-Reply-To: <20120312203451.GA16773@kroah.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 09:34 PM, Greg KH wrote:
> I'm announcing the release of the 3.0.24 kernel.
...
> Heiko Carstens (1): compat: fix compile breakage on s390

It looks like we need the same fix as for 2.6.32.59:
arch/s390/kernel/setup.c: In function 'setup_addressing_mode':
arch/s390/kernel/setup.c:328: error: 'PSW32_ASC_PRIMARY' undeclared
(first use in this function)
arch/s390/kernel/setup.c:328: error: (Each undeclared identifier is
reported only once
arch/s390/kernel/setup.c:328: error: for each function it appears in.)

regards,
-- 
js
suse labs
