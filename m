Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab3AHQqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:46:45 -0500
Received: from mail127.messagelabs.com ([216.82.250.115]:52900 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab3AHQqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:46:43 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-127.messagelabs.com!1357663598!8103216!6
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.8; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Abbott <abbotti@mev.co.uk>
Date: Tue, 8 Jan 2013 10:46:38 -0600
Subject: RE: linux-next: build failure after merge of the staging tree
Thread-Topic: linux-next: build failure after merge of the staging tree
Thread-Index: Ac3tWNMja1IzWgACSC+41jDwWCJkUQAZqBww
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206D6C990A5@AUSP01VMBX24.collaborationhost.net>
References: <20130108132352.dbabdc281512cdaffbae5ae9@canb.auug.org.au>
	<20130108042730.GA3936@kroah.com>
 <20130108152951.9fa6165c918e52ab5cfac435@canb.auug.org.au>
In-Reply-To: <20130108152951.9fa6165c918e52ab5cfac435@canb.auug.org.au>
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

On Monday, January 07, 2013 9:30 PM, Stephen Rothwell wrote:
> On Mon, 7 Jan 2013 20:27:30 -0800 Greg KH <greg@kroah.com> wrote:
>> On Tue, Jan 08, 2013 at 01:23:52PM +1100, Stephen Rothwell wrote:
>>> After merging the staging tree, today's linux-next build (x86_64
>>> allmodconfig) failed like this:
>>> 
>>> drivers/staging/comedi/comedi_fops.c: In function 'comedi_unlocked_ioctl':
>>> drivers/staging/comedi/comedi_fops.c:1665:4: error: 'dev_file_info' undeclared (first use in this function)
>>> 
>>> Caused by commit 4da5fa9a439f ("staging: comedi: use comedi_dev_from_minor
>>> ()") interacting with commit 7d3135af399e ("staging: comedi: prevent
>>> auto-unconfig of manually configured devices") from the staging.current
>>> tree.
>>> 
>>> I just reverted the latter commit in the hope that the bug is fixed in
>>> some other way in the staging tree.
>> 
>> Yes, I had to do some manual fixup when merging the branches together to
>> get it to work properly, which is what I did in my staging-next tree.
>> As the fixup was done in the merge commit, maybe you didn't get it when
>> you did the pull?
>
> Presumably not (my top of staging-next is d7f9729f6e06) - it was changing
> pretty rapidly this morning as I was fetching trees ...
>
> At least it will be OK tomorrow.

Greg's staging tree on git.kernel.org looks correct.

If there is anything I need to do to help resolve this please let me know.

Thanks,
Hartley

