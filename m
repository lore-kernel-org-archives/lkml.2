Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab1JWOdL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 10:33:11 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:4845 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab1JWOdJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 10:33:09 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Jiri Kosina" <jkosina@suse.cz>
Subject: RE: [PATCH 1/1] Staging: hv: mousevsc: Move the mouse driver out of
 staging
Thread-Topic: [PATCH 1/1] Staging: hv: mousevsc: Move the mouse driver out
 of staging
Thread-Index: AQHMiv2KcmQwABJKa0ij2IuJiEaIS5WKCPWAgAABexA=
Date: Sun, 23 Oct 2011 14:33:07 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA33663@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1318658907-16698-1-git-send-email-kys@microsoft.com>
 <20111023072427.GA13268@core.coreip.homeip.net>
In-Reply-To: <20111023072427.GA13268@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Sunday, October 23, 2011 3:24 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; linux-
> input@vger.kernel.org; Haiyang Zhang; Jiri Kosina
> Subject: Re: [PATCH 1/1] Staging: hv: mousevsc: Move the mouse driver out of
> staging
> 
> Hi K. Y.,
> 
> On Fri, Oct 14, 2011 at 11:08:27PM -0700, K. Y. Srinivasan wrote:
> > In preparation for moving the mouse driver out of staging, seek community
> > review of the mouse driver code.
> >
> 
> Because it is a HID driver it should go through Jiri Kosina's tree
> (CCed). Still, a few comments below.

Thanks Dmitry. I will address the comments you have given me, and will
work with Jiri to get this driver out of staging.

Regards,

K. Y

