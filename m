Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab0HRIv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 04:51:29 -0400
Received: from adelie.canonical.com ([91.189.90.139]:54737 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab0HRIv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 04:51:26 -0400
Message-ID: <4C6B9F00.8050409@canonical.com>
Date: Wed, 18 Aug 2010 16:51:12 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@novell.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
        Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Len Brown <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 5/8] ideapad: use EC command to control camera
References: <1282120564-11324-1-git-send-email-ike.pan@canonical.com> <1282120695-11503-1-git-send-email-ike.pan@canonical.com> <201008181042.39943.oneukum@suse.de>
In-Reply-To: <201008181042.39943.oneukum@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you give me an example that I can follow? Just point out which C file
I shall read. no much knowledge about generic power framework.

Thanks

On 08/18/2010 04:42 PM, Oliver Neukum wrote:
> Am Mittwoch, 18. August 2010, 10:38:15 schrieb Ike Panhc:
>> Signed-off-by: Ike Panhc <ike.pan@canonical.com>
>> ---
>>  drivers/platform/x86/ideapad_acpi.c |   16 +++++++++++-----
>>  1 files changed, 11 insertions(+), 5 deletions(-)
> 
> Hi,
> 
> wouldn't it be appropriate to integrate such switches into the generic
> power framework?
> 
> 	Regards
> 		Oliver

