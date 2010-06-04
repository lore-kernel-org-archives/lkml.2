Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab0FDKOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 06:14:12 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:59414 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab0FDKOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 06:14:09 -0400
Message-ID: <4C08D1EF.4000104@free.fr>
Date: Fri, 04 Jun 2010 12:14:07 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: mount namespace : who mounted what ?
References: <4C080ABD.5040902@free.fr> <20100604040158.GZ31073@ZenIV.linux.org.uk>
In-Reply-To: <20100604040158.GZ31073@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2010 06:01 AM, Al Viro wrote:
> On Thu, Jun 03, 2010 at 10:04:13PM +0200, Daniel Lezcano wrote:
>    
>> Hi all,
>>
>> I was wondering, in a new mount namespace, if it is possible to know
>> which mount points were inherited and which were mounted in a new
>> namespace ?
>>
>> I looked at /proc/<pid>/mountinfo and investigated a bit on the
>> mount id, but this one is not reliable as it changes in the new
>> namespace. The /proc/<pid>/mounts file shows all the mount points
>> visible for the process inherited or not.
>>      
> No more than "had it been this process that mmaped that area or was it
> inherited from the parent?"
>    

Ok, thanks.

I thought it may be interessting to add this information in the procfs 
(eg. /proc/<pid>/mountprivate) but wrt your remark that should have no 
sense as, to be consistent, we should do the same for all kind of 
inherited resources.
