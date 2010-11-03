Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab0KCSQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 14:16:05 -0400
Received: from kroah.org ([198.145.64.141]:54571 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260Ab0KCSQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 14:16:03 -0400
Date: Wed, 3 Nov 2010 11:06:24 -0700
From: Greg KH <greg@kroah.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: cdhmanning@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/9] Add yaffs Kconfig and Makefile
Message-ID: <20101103180624.GC7441@kroah.com>
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com> <1288803204-3849-2-git-send-email-cdhmanning@gmail.com> <20101103174607.GA6777@kroah.com> <4CD1A228.5060107@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD1A228.5060107@caviumnetworks.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 10:55:52AM -0700, David Daney wrote:
> On 11/03/2010 10:46 AM, Greg KH wrote:
>> On Thu, Nov 04, 2010 at 05:53:16AM +1300, cdhmanning@gmail.com wrote:
>>> From: Charles Manning<cdhmanning@gmail.com>
>>>
>>> Adding yaffs2 file system.
>>>
>>> Signed-off-by: Charles Manning<cdhmanning@gmail.com>
>>> ---
>>>   fs/yaffs2/Kconfig  |  190 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>   fs/yaffs2/Makefile |   17 +++++
>>
>> Don't do this as your first patch, make it your last one.  Otherwise the
>> build will break when you apply this one to the tree.
>>
>
> In Charles's defense, the changed to fs/Kconfig and fs/Makefile are not 
> made until the last patch, so buildability should be preserved as-is.

Doh, you are right, sorry about that.

Nevermind :)
