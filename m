Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118Ab2EIQDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:03:23 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:23696 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757952Ab2EIQDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:03:20 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-132.messagelabs.com!1336579398!11091131!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Ian Abbott <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Wed, 9 May 2012 11:03:16 -0500
Subject: RE: [PATCH] staging: comedi: remove __user annotation inside of
 struct's
Thread-Topic: [PATCH] staging: comedi: remove __user annotation inside of
 struct's
Thread-Index: Ac0t/GAtf2wNRPr4SdW6+Rggu3C90wAAKBEQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698A17870@AUSP01VMBX24.collaborationhost.net>
References: <201205081641.00358.hartleys@visionengravers.com>
 <ADE657CA350FB648AAC2C43247A983F0020698A1774D@AUSP01VMBX24.collaborationhost.net>
 <4FAA44D7.1040209@mev.co.uk> <20120509142436.GC11695@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F0020698A17862@AUSP01VMBX24.collaborationhost.net>
 <20120509155653.GA23058@kroah.com>
In-Reply-To: <20120509155653.GA23058@kroah.com>
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

On Wednesday, May 09, 2012 8:57 AM, gregkh@linuxfoundation.org wrote:
> On Wed, May 09, 2012 at 10:52:34AM -0500, H Hartley Sweeten wrote:
>> On Wednesday, May 09, 2012 7:25 AM, gregkh@linuxfoundation.org wrote:
>>> When the kernel exports .h files, stuff like this should work
>>> "automatically", so there is no need to not put __user markings.
>>>
>>> So please, yes, continue to work to get this correct, it is very
>>> essencial to ensure we don't mess stuff up.
>> 
>> Greg,
>> 
>> Based on the discussion I assume this patch is ok then. Do you
>> want me to repost it?
>
> Sure, I'll review it with the other patches you have sent later today.

Will do!

>> I'll work on fixing the other issues with the user <-> kernel transitions.
>
> Wonderful, thanks for the work you are doing on this code, it's greatly
> appreciated.

Glad I can help!

Regards,
Hartley

