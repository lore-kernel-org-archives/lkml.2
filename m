Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab0HRQjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:39:41 -0400
Received: from adsl-99-17-64-89.dsl.sfldmi.sbcglobal.net ([99.17.64.89]:53495
	"EHLO crunch.scalableinformatics.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750876Ab0HRQjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:39:37 -0400
X-Greylist: delayed 631 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Aug 2010 12:39:37 EDT
Message-ID: <4C6C0A30.1070008@scalableinformatics.com>
Date: Wed, 18 Aug 2010 12:28:32 -0400
From: Joe Landman <landman@scalableinformatics.com>
Reply-To: landman@scalableinformatics.com
Organization: Scalable Informatics
User-Agent: Thunderbird 2.0.0.24 (X11/20100623)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Chetan Loke <generationgnu@yahoo.com>,
        scst-devel <scst-devel@lists.sourceforge.net>,
        Vladislav Bolkhovitin <vst@vlnb.net>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [Scst-devel] Fwd: Re:  linuxcon 2010...
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com> <1282144271.3035.31.camel@mulgrave.site>
In-Reply-To: <1282144271.3035.31.camel@mulgrave.site>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:

>> During the open panel, my question was really specific - 
>>
>> Q) What is the future of a SCSI-target subsystem in linux. Which 
>>    target engine/subsystem can we expect?
>>
>> Your answer) There is place for only 1 target-subsystem in the Linux
>> scsi stack and in the LSF summit the decision was taken to merge LIO.
>> Has that
>> decision changed since the summit?
> 
> The decision hasn't been taken to merge LIO, but based on what happened
> at the summit, I think it's the most viable candidate and will likely be
> merged by 2.6.37

Quick question ... will LIO support SRP?  I should probably run over to 
their lists and ask, but a quick inspection of their site this morning 
shows that they are mostly iSCSI and FC focused.  (LIO folks, please 
feel free to step up and comment)

I'd certainly like to see a single framework, but not at the cost of 
losing important (to us) functionality.  We'd like to continue to use 
SRP, and iSCSI.  We'd like to use iSER (which is in the tgt stack) which 
LIO would give us when merged with tgt.  We are currently using SCST's 
iSCSI and SRP stack within our products.

I believe this also affects the OFED folks, as SRP is one of their 
services (based upon SCST).

Any guidance (in a general sense on the target side, not necessarily 
specific to LIO) on this would be appreciated.  SCST has been a good 
system for us to work with.  I'd hate to lose its functionality, and 
have us be forced to re-engineer some of our backend logic to work 
around the missing bits.  Thanks!

Regards,

Joe

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/jackrabbit
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
