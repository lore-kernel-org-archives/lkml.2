Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab2FLSbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:31:48 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:20760 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab2FLSbq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:31:46 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-160.messagelabs.com!1339525902!9290416!8
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>
Date: Tue, 12 Jun 2012 13:31:38 -0500
Subject: RE: [PATCH] staging: comedi: cleanup alloc_subdevices
Thread-Topic: [PATCH] staging: comedi: cleanup alloc_subdevices
Thread-Index: Ac1IPKyjZfPMl1fWSOC5B0ZimP/TAAAjJtGg
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698DBC6D7@AUSP01VMBX24.collaborationhost.net>
References: <201206071508.15674.hartleys@visionengravers.com>
 <20120611235657.GA26721@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F0020698DBC4A9@AUSP01VMBX24.collaborationhost.net>
 <20120612004421.GA30997@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F0020698DBC4B9@AUSP01VMBX24.collaborationhost.net>
 <20120612014239.GA32087@kroah.com>
In-Reply-To: <20120612014239.GA32087@kroah.com>
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

On Monday, June 11, 2012 6:43 PM, Greg KH wrote:
> On Mon, Jun 11, 2012 at 07:49:46PM -0500, H Hartley Sweeten wrote:
>> Also, I have never done local commits to my Linux-next tree so I'm not
>> sure how to proceed with the incremental patches. If it's ok with you
>> I'll just wait for each patch to go into staging.
>
> Create a brach from the one you are working on:
> 	git branch -b my_branch
> make a change and commit it
> commit another one
> and so on.
> then create the patches:
> 	git format-patch original_branch_name..my_branch
> and use git send-email to send them off in order.
>
> Otherwise we are going to take 7 weeks when I apply one of your patches
> a week :)

Greg,

I did as you described above and have the 7 patches ready but I just
noticed you have already applied the first one.

Should I post the entire series and note that the first one is already
applied?

Thanks,
Hartley

