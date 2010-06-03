Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703Ab0FCCxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 22:53:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38533 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933637Ab0FCCxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 22:53:17 -0400
Message-ID: <4C07179F.5080106@vflare.org>
Date: Thu, 03 Jun 2010 08:16:55 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Minchan Kim <minchan.kim@gmail.com>, chris.mason@oracle.com,
       viro@zeniv.linux.org.uk, akpm@linux-foundation.org, adilger@Sun.COM,
       tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, jeremy@goop.org,
       JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de,
       dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com,
       konrad.wilk@oracle.com
Subject: Re: [PATCH V2 0/7] Cleancache (was Transcendent Memory): overview
References: <20100528173510.GA12166@ca-server1.us.oracle.comAANLkTilV-4_QaNq5O0WSplDx1Oq7JvkgVrEiR1rgf1up@mail.gmail.com> <1d88619a-bb1e-493f-ad96-bf204b60938d@default 20100602163827.GA5450@barrios-desktop> <489aa002-6d42-4dd5-bb66-81c665f8cdd1@default>
In-Reply-To: <489aa002-6d42-4dd5-bb66-81c665f8cdd1@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2010 04:32 AM, Dan Magenheimer wrote:
>> From: Minchan Kim [mailto:minchan.kim@gmail.com]
> 
>>> I am also eagerly awaiting Nitin Gupta's cleancache backend
>>> and implementation to do in-kernel page cache compression.
>>
>> Do Nitin say he will make backend of cleancache for
>> page cache compression?
>>
>> It would be good feature.
>> I have a interest, too. :)
> 
> That was Nitin's plan for his GSOC project when we last discussed
> this.  Nitin is on the cc list and can comment if this has
> changed.
> 


Yes, I have just started work on in-kernel page cache compression
backend for cleancache :)

Thanks,
Nitin
