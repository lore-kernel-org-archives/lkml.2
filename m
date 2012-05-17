Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407Ab2EQQia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:38:30 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:64163 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335Ab2EQQi2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:38:28 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-132.messagelabs.com!1337272682!11899307!11
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>, Greg KH <gregkh@linuxfoundation.org>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>
Date: Thu, 17 May 2012 11:38:07 -0500
Subject: RE: [PATCH] staging: comedi: Convert struct addi_board
 initialization to C99 format
Thread-Topic: [PATCH] staging: comedi: Convert struct addi_board
 initialization to C99 format
Thread-Index: Ac00RdGVi5lYJI4hSiGateZW4J4/sgABTv1g
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698AE0FF8@AUSP01VMBX24.collaborationhost.net>
References: <201205161751.56913.hartleys@visionengravers.com>
 <20120517021805.GA32592@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F00206986FBDDF@AUSP01VMBX24.collaborationhost.net>
 <4FB49E74.8030409@mev.co.uk> <20120517133221.GB5090@kroah.com>
 <4FB51FFA.3090800@mev.co.uk>
In-Reply-To: <4FB51FFA.3090800@mev.co.uk>
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

On Thursday, May 17, 2012 8:58 AM, Ian Abbott wrote:
> On 2012/05/17 02:32 PM, Greg KH wrote:
>> I thought a few years ago, either you, or someone else, said it would be
>> good to just delete them entirely.  Or am I making that up and just wish
>> it would be so?  :)
>
> I can't remember at my age!
>
> There was a guy who works for Addi-Data (Krauth Julien) who had trouble
> submitting patches to you directly (I was CC'd) back in
> September/October 2011, so I guess they'd be unhappy if the drivers were
> removed altogether!

I think they can be cleaned up. It's just going to take a bit of work. Of course
when it's done they probably will not look anything like they do now.

BTW, what actual hardware do you have available to test with?

Regards,
Hartley

