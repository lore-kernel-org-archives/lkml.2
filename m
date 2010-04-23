Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab0DWOKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 10:10:22 -0400
Received: from mail-out1.informatik.tu-muenchen.de ([131.159.0.8]:51593 "EHLO
	mail-out1.informatik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753203Ab0DWOKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 10:10:19 -0400
Message-ID: <4BD1AA46.2050007@mathtm.de>
Date: Fri, 23 Apr 2010 16:10:14 +0200
From: =?UTF-8?B?VGhvbWFzIE3DvGxsZXI=?= <thomas@mathtm.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Rusty Russell <rusty@rustcorp.com.au>, Shirley Ma <mashirle@us.ibm.com>,
       Shirley Ma <xma@us.ibm.com>
Subject: Re: [Bug #15719] virtio_net causing kernel BUG when running under
 VirtualBox
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.sRH.jRSzLB@tosh>
In-Reply-To: <YeFfFNFyTSF.A.sRH.jRSzLB@tosh>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed by commit 0e413f22e4c1cbfe12907e462a7d739a2e316f2b.

Regards
Thomas

On 20.04.2010 05:19, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15719
> Subject		: virtio_net causing kernel BUG when running under VirtualBox
> Submitter	: Thomas Müller <thomas@mathtm.de>
> Date		: 2010-03-27 14:32 (24 days old)
> First-Bad-Commit: http://kernel.org/git/linus/9ab86bbcf8be755256f0a5e994e0b38af6b4d399
> Message-ID	: <4BAE1707.2050803@mathtm.de>
> References	: http://marc.info/?l=linux-kernel&m=126970039227740&w=4
> Handled-By	: Shirley Ma <mashirle@us.ibm.com>
> 
> 

