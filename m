Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220Ab0KATNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:13:05 -0400
Received: from kroah.org ([198.145.64.141]:50844 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801Ab0KATND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:13:03 -0400
Date: Mon, 1 Nov 2010 12:04:52 -0700
From: Greg KH <greg@kroah.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Tracey Dent <tdent48227@gmail.com>, manningc2@actrix.gen.nz,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/29] Staging: Add yaffs2 filesystem
Message-ID: <20101101190452.GB5023@kroah.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com> <4CCF0D2B.6070308@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CCF0D2B.6070308@caviumnetworks.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 11:55:39AM -0700, David Daney wrote:
> On 11/01/2010 11:40 AM, Tracey Dent wrote:
>> The patch sets puts the yaffs2 filesystem in the staging directory.
>> It is all based on Charles git tree(http://github.com/cdhmanning/linux-yaffs-integration/).
>> Everything is compile tested and it builds.
>>
>> This only the inital support and I will be sending more cleanup patches.
>>
>> Greg can you add the patch set into your staging-next tree.
>> Also, It doesn't affect anything other than itself.
>>
>> Thanks,
>>
>> Tracey Dent
>
> I am confused.
>
> Are you and Charles Manning working together on this?
>
> Did you write all this code or did Charles?  If it was Charles, why are 
> there no From: and Signed-off-by headers for him?

Yeah, we need to get the authorship correct here.  Charles, do you ack
these patches?

thanks,

greg k-h
