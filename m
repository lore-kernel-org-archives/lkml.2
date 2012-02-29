Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030833Ab2B2Hfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 02:35:44 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:34063
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755793Ab2B2Hfm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 02:35:42 -0500
X-SpamScore: -33
X-BigFish: PS-33(zz9371I1be0IfecM168aJ542M1432N1a09J98dK14ffO4015Izz1202hzzz2fh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:157.55.61.13;KIP:(null);UIP:(null);IPV:NLI;H:CH1PRD0802HT007.namprd08.prod.outlook.com;RD:none;EFVD:NLI
From: Chris Kelly <ckelly@ozmodevices.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: build failure after merge of the final tree
 (staging tree related)
Thread-Topic: linux-next: build failure after merge of the final tree
 (staging tree related)
Thread-Index: AQHM9R9H2So6mvM4AUKIL+SJlIfCzJZRP+YAgAI76MA=
Date: Wed, 29 Feb 2012 07:35:35 +0000
Message-ID: <57C28D85C66F5C49B9E212CBFAFDAC1F23010F80@CH1PRD0802MB120.namprd08.prod.outlook.com>
References: <20120227181303.9aa93b8a8ed02428e9310c5e@canb.auug.org.au>
 <20120227211630.GA18418@kroah.com>
In-Reply-To: <20120227211630.GA18418@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.42.110.8]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I believe I understand the cause of the problem and would like to submit a patch to fix it. However, I am unclear on what the starting point is given that the final patch was reverted from linux-next. Do I assume that patch will be reapplied before the applying the new patch or should I provide another patch to reapply the reverted patch? Is it acceptable to submit patches generated against the head of linux-next?

Before submitting the patch, I would like to test that the patch really does fix the issue found by Stephen. Since it doesn't occur when building for x32 or x64 then I need to setup a PowerPC cross-compile tool chain. Do you have any suggestions as to where I can pull a prebuilt tool chain or do I need to build directly from the GNU sources.

Many thanks for your help
Kind regards
Chris Kelly 

-----Original Message-----
From: Greg KH [mailto:gregkh@linuxfoundation.org] 
Sent: 27 February 2012 9:17 PM
To: Stephen Rothwell
Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Chris Kelly
Subject: Re: linux-next: build failure after merge of the final tree (staging tree related)

On Mon, Feb 27, 2012 at 06:13:03PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build
> (powerpc_allyesconfig) failed like this:
> 
> drivers/staging/ozwpan/ozcdev.c: In function 'oz_cdev_ioctl':
> drivers/staging/ozwpan/ozcdev.c:284:7: error: case label does not reduce to an integer constant
> 
> Caused by commit 23af8c2a088f ("staging: ozwpan: Added character device
> support") from the staging tree.
> 
> I reverted commit b0406db5b3e4 ("staging: ozwpan: Plumbed in Kconfig and
> Kbuild") for today.

Thanks, Chris, care to fix this up and send me a patch?

greg k-h


