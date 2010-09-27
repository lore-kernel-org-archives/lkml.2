Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759978Ab0I0R5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 13:57:38 -0400
Received: from maila.microsoft.com ([131.107.115.212]:41384 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127Ab0I0R5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 13:57:37 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: Greg KH <greg@kroah.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: RE: [PATCH 1/1] Rename camel case variables in channel.c  (updated
 again)
Thread-Topic: [PATCH 1/1] Rename camel case variables in channel.c  (updated
 again)
Thread-Index: AQHLXm11ZRAaFsNQLUOl9exxHok0FA==
Date: Mon, 27 Sep 2010 17:57:32 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7289F13EFE@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7289ED89CF@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <1FB5E1D5CA062146B38059374562DF7289EDBC9E@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20100927011943.GA6936@kroah.com>
 <1FB5E1D5CA062146B38059374562DF7289F076BD@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20100927061029.GC22319@suse.de>
In-Reply-To: <20100927061029.GC22319@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Monday, September 27, 2010 2:10 AM
> >
> > I checked the email I sent on Friday, it was in "Plain Text" format.
> > This was the same format I used for my patches which were accepted
> > previously. Maybe Outlook server converted this one to MIME format?
> > I'm not sure.
> >
> > I have attached the patch in Linux text format, which I have verified
> > with 'patch' command. No error:
> >
> > linux-next> patch -p1 <0924.2-Rename-camel-case-variables-in-
> channel.c.patch
> > patching file drivers/staging/hv/channel.c
> > linux-next>
> >
> > Could you try the attached patch on your side?
> 
> Yes, that worked, but you do realize you attached it in base64 mode,
> right?  That sure isn't going to work...

While we are setting up a new mail server for sending patches, could you
apply attached patches in the meanwhile? So I can continue to work on
more patches.

This attachment can also be downloaded by this Linux command as plain text
without any encoding:
  wget http://driverdev.linuxdriverproject.org/pipermail/devel/attachments/20100927/51d954b0/attachment.obj

Thanks,

- Haiyang

