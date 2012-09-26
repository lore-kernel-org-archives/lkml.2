Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab2IZVNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 17:13:37 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:30079 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab2IZVNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 17:13:36 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-127.messagelabs.com!1348694015!8880024!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.3; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 26 Sep 2012 16:13:33 -0500
Subject: RE: staging tree closed for 3.7
Thread-Topic: staging tree closed for 3.7
Thread-Index: Ac2cIkpleFRIYE4tR2KA5TSlgbNEdAACTJjQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206B20BEE19@AUSP01VMBX24.collaborationhost.net>
References: <20120926175606.GA10762@kroah.com>
 <20120926175634.GB10762@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F00206B20BED5D@AUSP01VMBX24.collaborationhost.net>
 <20120926200527.GC9994@kroah.com>
In-Reply-To: <20120926200527.GC9994@kroah.com>
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

On Wednesday, September 26, 2012 1:05 PM, Greg Kroah-Hartman wrote:
> On Wed, Sep 26, 2012 at 01:47:11PM -0500, H Hartley Sweeten wrote:
>> On Wednesday, September 26, 2012 10:57 AM, Greg Kroah-Hartman wrote:
>>> On Wed, Sep 26, 2012 at 10:56:06AM -0700, Greg Kroah-Hartman wrote:
>>>> 
>>>> With 3.6 about to be released, I've now closed the 3.7 staging-next tree
>>>> for new features / cleanups.  It's bug-fixes only now until 3.7-rc1 is
>>>> out.
>>>
>>> Oh, and if I've missed any patches that people have sent me already,
>>> please let me know, because I don't have them anymore.
>> 
>> Greg,
>> 
>> What about my "staging: comedi: drivers: use comedi_fc.h cmdtest helpers"?
>> 
>> It's quite large but does have decent diffstat:
>> 46 files changed, 766 insertions(+), 1997 deletions(-)
>
> Care to resend it?  I thought that was part of the __user rework, my
> apologies.

Not a problem. Just reposted it (v2).

>> If it doesn't apply due to conflicts, or you would rather just wait
>> until 3.7-rc1, it's not a problem.
>> 
>> I have updated the patch to fix the typo Ian pointed out and to remove
>> the Reported-by signoff from Dan if you would like me to repost it.
>
> Please redo it and resend it, that must have been why I didn't apply it,
> I was waiting for a newer version :)

If there is a merge issue please let me know. If so I'll wait until 3.7-rc1 is
out and rebase the patch.

Thanks!
Hartley

