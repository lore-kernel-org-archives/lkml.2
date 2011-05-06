Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab1EFMlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 08:41:49 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:49636 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751420Ab1EFMls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 08:41:48 -0400
Message-ID: <4DC3EC8B.6060109@mimc.co.uk>
Date: Fri, 06 May 2011 13:41:47 +0100
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Jamie Iles <jamie.iles@picochip.com>, Jamie Iles <jamie@jamieiles.com>
Subject: Re: [Bug #33092] [regression] 2.6.39-rc1 - Beagleboard usbnet broken
References: <Xp4OiTz83N.A.O0D.JVGvNB@chimera> <G9uL1cldhmL.A.rKF.XWGvNB@chimera>
In-Reply-To: <G9uL1cldhmL.A.rKF.XWGvNB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/04/11 20:46, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.38.  Please verify if it still should be listed and let the tracking team
> know (either way).

I have just tried the latest linus git and it is still broken.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=33092
> Subject		: [regression] 2.6.39-rc1 - Beagleboard usbnet broken
> Submitter	: Mark Jackson <mpfj-list@mimc.co.uk>
> Date		: 2011-04-04 9:22 (27 days old)
> First-Bad-Commit: http://git.kernel.org/linus/087809fce28f50098d9c3ef1a6865c722f23afd2
> Message-ID	: <4D998DC9.3040109@mimc.co.uk>
> References	: http://marc.info/?l=linux-kernel&m=130191386508831&w=2

Regards
Mark
