Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab0CXR6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:58:08 -0400
Received: from daytona.panasas.com ([67.152.220.89]:10254 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932629Ab0CXR6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:58:03 -0400
Message-ID: <4BAA52A8.2080304@panasas.com>
Date: Wed, 24 Mar 2010 19:58:00 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
References: <4BAA3493.1030802@panasas.com>	<20100324160037.GP30031@ZenIV.linux.org.uk>	<4BAA3828.2070506@panasas.com>	<20100324160754.GQ30031@ZenIV.linux.org.uk>	<4BAA398C.5050901@panasas.com>	<20100324163948.GR30031@ZenIV.linux.org.uk>	<4BAA48A3.1030801@panasas.com>	<4BAA4CAC.6060104@panasas.com> <4BAA5035.1060906@panasas.com>
In-Reply-To: <4BAA5035.1060906@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Mar 2010 17:58:02.0870 (UTC) FILETIME=[8C4C3160:01CACB7B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 07:47 PM, Boaz Harrosh wrote:
>>> On 03/24/2010 06:39 PM, Al Viro wrote:
>>>> On Wed, Mar 24, 2010 at 06:10:52PM +0200, Boaz Harrosh wrote:
>>>>> On 03/24/2010 06:07 PM, Al Viro wrote:
>>>>>>>> Bloody impressive...  Does that happen to underlying fs or to what you
>>>>>>>> are seeing via NFS?
>>>>>>>
>>>>>>> Only via NFS. All local access is fine.
>>>>>>>
<snip>

Al hi

Would you like to attempt a revert of this patch (or group of patches)
Just to get rid of the thought that git bisect was just peeking the
wrong guy. Maybe it's just something else? Can you understand the
relevance of all this?

(I'll try other setups as well but tomorrow, it's getting late out here)
Thanks for your help
Boaz
