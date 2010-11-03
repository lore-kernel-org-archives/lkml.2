Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab0KCRz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 13:55:57 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:17557 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab0KCRzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 13:55:53 -0400
Message-ID: <4CD1A228.5060107@caviumnetworks.com>
Date: Wed, 03 Nov 2010 10:55:52 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: cdhmanning@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/9] Add yaffs Kconfig and Makefile
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com> <1288803204-3849-2-git-send-email-cdhmanning@gmail.com> <20101103174607.GA6777@kroah.com>
In-Reply-To: <20101103174607.GA6777@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Nov 2010 17:56:27.0833 (UTC) FILETIME=[702EB290:01CB7B80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2010 10:46 AM, Greg KH wrote:
> On Thu, Nov 04, 2010 at 05:53:16AM +1300, cdhmanning@gmail.com wrote:
>> From: Charles Manning<cdhmanning@gmail.com>
>>
>> Adding yaffs2 file system.
>>
>> Signed-off-by: Charles Manning<cdhmanning@gmail.com>
>> ---
>>   fs/yaffs2/Kconfig  |  190 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/yaffs2/Makefile |   17 +++++
>
> Don't do this as your first patch, make it your last one.  Otherwise the
> build will break when you apply this one to the tree.
>

In Charles's defense, the changed to fs/Kconfig and fs/Makefile are not 
made until the last patch, so buildability should be preserved as-is.

Thanks,
David Daney
