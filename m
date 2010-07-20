Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312Ab0GTR0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 13:26:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38237 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab0GTR0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 13:26:19 -0400
Message-ID: <4C45DC30.5000308@zytor.com>
Date: Tue, 20 Jul 2010 10:26:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] x86/pci/mrst: add extra check in fixed bar detection
References: <1279306706-27087-1-git-send-email-jacob.jun.pan@linux.intel.com> <4C45DA7F.1060801@candelatech.com>
In-Reply-To: <4C45DA7F.1060801@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2010 10:18 AM, Ben Greear wrote:
> On 07/16/2010 11:58 AM, Jacob Pan wrote:
>> Fixed bar capability structure is searched in PCI extended configuration
>> space. We need to make sure there is a valid capability id to begin with
>> otherwise, the search code may stuck in a infinite loop which results in
>> boot hang.
>> This patch adds additional check for cap ID 0, which is also invalid.
> 
> I think this should be added to the stable tree for 2.6.34
> as well...
> 

Agreed. Greg, could you consider upstream
f82c3d71d6fd2e6a3e3416f09099e29087e39abf for -stable 2.6.34?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

