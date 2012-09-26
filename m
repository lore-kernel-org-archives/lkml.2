Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab2IZSrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:47:21 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:8170 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab2IZSrT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:47:19 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-132.messagelabs.com!1348685228!14655377!14
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.3; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
CC: Ian Abbott <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 26 Sep 2012 13:47:11 -0500
Subject: RE: staging tree closed for 3.7
Thread-Topic: staging tree closed for 3.7
Thread-Index: Ac2cEEczwvFpCo8gTLa6CEXZkMB5pwABobdg
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206B20BED5D@AUSP01VMBX24.collaborationhost.net>
References: <20120926175606.GA10762@kroah.com>
 <20120926175634.GB10762@kroah.com>
In-Reply-To: <20120926175634.GB10762@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 26, 2012 10:57 AM, Greg Kroah-Hartman wrote:
> On Wed, Sep 26, 2012 at 10:56:06AM -0700, Greg Kroah-Hartman wrote:
>> 
>> With 3.6 about to be released, I've now closed the 3.7 staging-next tree
>> for new features / cleanups.  It's bug-fixes only now until 3.7-rc1 is
>> out.
>
> Oh, and if I've missed any patches that people have sent me already,
> please let me know, because I don't have them anymore.

Greg,

What about my "staging: comedi: drivers: use comedi_fc.h cmdtest helpers"?

It's quite large but does have decent diffstat:
46 files changed, 766 insertions(+), 1997 deletions(-)

If it doesn't apply due to conflicts, or you would rather just wait
until 3.7-rc1, it's not a problem.

I have updated the patch to fix the typo Ian pointed out and to remove
the Reported-by signoff from Dan if you would like me to repost it.

Regards,
Hartley

