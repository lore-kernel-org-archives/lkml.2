Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab2IQLG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 07:06:56 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:41253 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755788Ab2IQLGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:06:53 -0400
Subject: Re: [PATCH] x86: Switch to vga console only if framebuffer details
 are missing
From: Matt Fleming <matt@console-pimps.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg@redhat.com>,
        Olof Johansson <olof@lixom.net>, Peter Jones <pjones@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
In-Reply-To: <20120917120047.42b520ac@pyramind.ukuu.org.uk>
References: <1347877748-11766-1-git-send-email-matt@console-pimps.org>
	 <20120917120047.42b520ac@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Sep 2012 12:03:40 +0100
Message-ID: <1347879820.12641.3.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-17 at 12:00 +0100, Alan Cox wrote:
> On Mon, 17 Sep 2012 11:29:08 +0100
> Matt Fleming <matt@console-pimps.org> wrote:
> 
> > From: Matt Fleming <matt.fleming@intel.com>
> > 
> > The efi_enabled variable has come to mean "Do we have EFI runtime
> > services available?". However, lack of EFI runtime services does not
> > mean that we should switch to using the VGA console. Provided that the
> > boot loader passed the dimensions of the EFI framebuffer there is no
> > reason we can't use efifb.
> 
> Speed is the obvious one. vga con is fast, efifb is not

Right, and that's an entirely valid reason for wanting vga con over
efifb, but in that case users should just disable the efifb driver.

-- 
Matt Fleming, Intel Open Source Technology Center

