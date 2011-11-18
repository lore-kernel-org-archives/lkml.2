Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab1KRS02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 13:26:28 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:44384 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753070Ab1KRS01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 13:26:27 -0500
Message-ID: <4EC6A2D6.10702@xenotime.net>
Date: Fri, 18 Nov 2011 10:24:22 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] Documentation for sysfs attributes for 3.3 (xen related)
References: <1321640393-19708-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1321640393-19708-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 10:19 AM, Konrad Rzeszutek Wilk wrote:
> Please accept the following two patches that describe the
> SysFS of some of the Xen drivers. Thank you.
> 
> David Vrabel (2):
>       xen: document balloon driver sysfs files
>       xen: document backend sysfs files
> 
>  Documentation/ABI/stable/sysfs-bus-xen-backend     |   75 +++++++++++++++++++
>  .../ABI/stable/sysfs-devices-system-xen_memory     |   77 ++++++++++++++++++++
>  2 files changed, 152 insertions(+), 0 deletions(-)

Hey,

Documentation/ABI/ patches should go to GregKH.

Greg, can we clarify that in MAINTAINERS ?

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
