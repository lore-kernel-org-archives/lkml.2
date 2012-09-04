Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab2IDSjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 14:39:41 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:32527 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504Ab2IDSjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 14:39:40 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-127.messagelabs.com!1346783949!6774598!41
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.3; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>
Date: Tue, 4 Sep 2012 13:39:22 -0500
Subject: RE: [PATCH] staging: comedi: remove pointer math for subdevice
 access
Thread-Topic: [PATCH] staging: comedi: remove pointer math for subdevice
 access
Thread-Index: Ac2KzCYuAweXqdoERxah5ZP6FdlFhwAAGA2Q
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206B1D9F966@AUSP01VMBX24.collaborationhost.net>
References: <201208201659.16987.hartleys@visionengravers.com>
 <20120904183333.GA31939@kroah.com>
In-Reply-To: <20120904183333.GA31939@kroah.com>
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

On Tuesday, September 04, 2012 11:34 AM, Greg KH wrote:
> On Mon, Aug 20, 2012 at 04:59:16PM -0700, H Hartley Sweeten wrote:
>> Convert all the comedi_subdevice pointer access from pointer
>> math to array access.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Dan Carpenter <dan.carpenter@oracle.com>
>> Cc: Ian Abbott <abbotti@mev.co.uk>
>
> This patch doesn't seem to apply, care to break it up into smaller
> pieces, and also fold in your "fix the build" patch as well?  That way
> we have a chance to get it applied :)

Not a problem. Thanks!

Hartley

