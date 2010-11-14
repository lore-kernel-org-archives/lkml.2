Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab0KNRK3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 12:10:29 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:43846 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab0KNRK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 12:10:28 -0500
To: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
Cc: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [E1000-devel] 2.6.36 abrupt total e1000e carrier loss (cured by reboot)
References: <87ocaaszx1.fsf@spindle.srvr.nix>
	<EA929A9653AAE14F841771FB1DE5A136602815A3C7@rrsmsx501.amr.corp.intel.com>
	<87zktsskua.fsf@spindle.srvr.nix>
	<1288837586.2835.3.camel@jbrandeb-mobl2>
	<87wrooi6qu.fsf@spindle.srvr.nix>
	<EA929A9653AAE14F841771FB1DE5A13660283A6815@rrsmsx501.amr.corp.intel.com>
	<87sjzbin20.fsf@spindle.srvr.nix>
From: Nix <nix@esperi.org.uk>
Emacs: more boundary conditions than the Middle East.
Date: Sun, 14 Nov 2010 17:10:02 +0000
In-Reply-To: <87sjzbin20.fsf@spindle.srvr.nix> (nix@esperi.org.uk's message of "Mon, 08 Nov 2010 20:21:27 +0000")
Message-ID: <87k4kfq1at.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 Nov 2010, nix@esperi.org.uk stated:

> On 8 Nov 2010, Emil S. Tantilov verbalised:
>
>> Nix wrote:
>>> For the record, cherry-picking
>>> ff10e13cd06f3dbe90e9fffc3c2dd2057a116e4b (the periodic
>>> phy-crash-and-reset check) atop 2.6.36 seems to have fixed it: at
>>> least, the machine has been up for a day now without trouble. This
>>> commit doesn't seem to be in Greg's stable-queue yet, but seems like
>>> a good candidate. 
>>
>> This patch should have no effect on your issue if it is indeed ASPM related.
>
> Interesting. I just noticed that it was testing for exactly the same
> symptoms as I was observing (registers suddenly filled with 0xff) and
> resetting the card, and thought it might help (plus it's easier than
> installing an out-of-tree module and I'm lazy so I tried it first).

It didn't help. Unfortunately, neither did the upstream e1000e-1.2.17
module. I have now seen this network-dead bug with basic 2.6.36, with
2.6.36 plus the commit named above, and with 2.6.36 plus e1000e-1.2.17.

Any debugging I can do, just drop me a line. I'm really quite used to
rebooting this system now, what with this *and* the NFS rpc.mountd-
imploding-on-bootup bug biting simultaneously.
