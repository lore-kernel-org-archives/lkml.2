Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0KASzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:55:49 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5658 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab0KASzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:55:44 -0400
Message-ID: <4CCF0D2B.6070308@caviumnetworks.com>
Date: Mon, 01 Nov 2010 11:55:39 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Tracey Dent <tdent48227@gmail.com>, greg@kroah.com,
        manningc2@actrix.gen.nz
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/29] Staging: Add yaffs2 filesystem
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
In-Reply-To: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Nov 2010 18:56:17.0118 (UTC) FILETIME=[76BC9FE0:01CB79F6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2010 11:40 AM, Tracey Dent wrote:
> The patch sets puts the yaffs2 filesystem in the staging directory.
> It is all based on Charles git tree(http://github.com/cdhmanning/linux-yaffs-integration/).
> Everything is compile tested and it builds.
>
> This only the inital support and I will be sending more cleanup patches.
>
> Greg can you add the patch set into your staging-next tree.
> Also, It doesn't affect anything other than itself.
>
> Thanks,
>
> Tracey Dent

I am confused.

Are you and Charles Manning working together on this?

Did you write all this code or did Charles?  If it was Charles, why are 
there no From: and Signed-off-by headers for him?

Thanks in advance for enlightening us as to what is going on here,
David Daney
