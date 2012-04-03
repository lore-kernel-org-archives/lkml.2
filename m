Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab2DCFzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 01:55:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62735 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab2DCFz2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 01:55:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120402194049.06B613E314E@localhost>
References: <1333193818-3984-1-git-send-email-shubhrajyoti@ti.com>
	<20120402194049.06B613E314E@localhost>
Date: Tue, 3 Apr 2012 11:25:26 +0530
Message-ID: <CAM=Q2cse5_mZtfNchE+uYpNPLd+_TSTFswxhfk0feaoMqmT7eA@mail.gmail.com>
Subject: Re: [PATCHv3 0/3] spi: omap2-mcspi: driver updates
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Shubhrajyoti D <shubhrajyoti@ti.com>,
        spi-devel-general@lists.sourceforge.net,
        Shubhrajyoti@ponder.secretlab.ca, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant

On Tue, Apr 3, 2012 at 1:10 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Sat, 31 Mar 2012 17:06:55 +0530, Shubhrajyoti D <shubhrajyoti@ti.com> wrote:
>> The patch series does the following cleanups
>> - Makes the driver use autosuspend
>> - Folds Benoit's bus_num removal patch in the series
>> - The tmp variable is used to write this can be optimised
>>  as it is not needed if the value is directly written.
>>  Acknowledge  Tarun for the suggestion.
>>
>> This is also available through
>> git     : git://gitorious.org/linus-tree/linus-tree.git
>> branch  : spi_next
>>
>> Rebased to Grant's spi/next branch.
>
> Merged, thanks.
Thanks ,

>
> BTW, it's easier to pull if you put the branch after the git URL (I
> can cut and paste all at once):
>
>        git://gitorious.org/linus-tree/linus-tree.git spi_next
>
> "git request-pull" can be your friend here.
>
OK good idea will do that.
