Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab1I0QaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 12:30:25 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:44458 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750997Ab1I0QaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 12:30:24 -0400
Message-ID: <4E81FA1E.3060702@xenotime.net>
Date: Tue, 27 Sep 2011 09:30:22 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: linux-next: Tree for Sept 27 (power/qos.c)
References: <20110927173530.ceae2e49537a81da65287bf3@canb.auug.org.au>
In-Reply-To: <20110927173530.ceae2e49537a81da65287bf3@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2011 12:35 AM, Stephen Rothwell wrote:
> Hi all,


When CONFIG_PM_SLEEP is not enabled:

drivers/base/power/qos.c:231:29: error: 'struct dev_pm_info' has no member named 'entry'


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
