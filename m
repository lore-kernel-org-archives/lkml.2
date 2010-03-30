Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab0C3HQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 03:16:10 -0400
Received: from adelie.canonical.com ([91.189.90.139]:48009 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab0C3HQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 03:16:08 -0400
Message-ID: <4BB1A532.6030502@canonical.com>
Date: Tue, 30 Mar 2010 09:16:02 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: reinette chatre <reinette.chatre@intel.com>,
       "adel.gadllah@gmail.com" <adel.gadllah@gmail.com>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "stable@kernel.org" <stable@kernel.org>,
       "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>
Subject: Re: patch iwlwifi-silence-tfds_in_queue-message.patch added to	2.6.32-stable
 tree
References: <12698953011038@site> <1269900575.2446.3425.camel@rchatre-DESK> <20100329222404.GA10927@suse.de>
In-Reply-To: <20100329222404.GA10927@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Mar 29, 2010 at 03:09:35PM -0700, reinette chatre wrote:
>> Hi,
>>
>> On Mon, 2010-03-29 at 13:41 -0700, gregkh@suse.de wrote:
>>> This is a note to let you know that we have just queued up the patch titled
>>>
>>>     Subject: iwlwifi: Silence tfds_in_queue message
>>>
>>> to the 2.6.32-stable tree.
>> [...]
>>
>> Please note that this patch is really just masking a problem introduced
>> by a 2.6.32 backported patch. The real fix is
>> https://patchwork.kernel.org/patch/86722/ which should be included in
>> 2.6.32.
> 
> What is the git commit id for that patch?  patchwork links don't help me
> at all.

There isn't one. The main problem only exists in 2.6.32.y
because the final hunk missed to remove the nfreed++ from
ouside the if.

Introduced by backport of in 2.6.32.y

commit a120e912eb51e347f36c71b60a1d13af74d30e83
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Fri Feb 19 15:47:33 2010 -0800

    iwlwifi: sanity check before counting number of tfds can be free


> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe stable-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

