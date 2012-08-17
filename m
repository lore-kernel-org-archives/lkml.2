Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332Ab2HQQQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:16:00 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:60668 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab2HQQPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:15:52 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-209.messagelabs.com!1345220139!7702301!21
X-Originating-IP: [216.166.12.178]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Fri, 17 Aug 2012 11:15:33 -0500
Subject: RE: [PATCH 00/35] staging: comedi: update comedi pci drivers
Thread-Topic: [PATCH 00/35] staging: comedi: update comedi pci drivers
Thread-Index: Ac18VIZWoGE1rmpdRvuF0N1dJRdrfwAPue7g
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206AAFDC0D6@AUSP01VMBX24.collaborationhost.net>
References: <201208161940.55761.hartleys@visionengravers.com>
 <502E046B.3030403@mev.co.uk>
In-Reply-To: <502E046B.3030403@mev.co.uk>
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

On Friday, August 17, 2012 1:44 AM, Ian Abbott wrote:
> On 2012-08-17 03:40, H Hartley Sweeten wrote:
>> Remove the manual legacy 'attach' callback in the comedi pci drivers
>> that have it stubbed out. The 'attach' callback is not optional in
>> the comedi core.
>
> Just to avoid confusion, I think Hartley meant "now optional" in the 
> above sentence!

Doh... Fat fingered that. Thanks!

Hartley
