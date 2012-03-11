Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab2CKWHG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 18:07:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63986 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab2CKWG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 18:06:58 -0400
Date: Sun, 11 Mar 2012 17:06:48 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Thomas Goirand <zigo@debian.org>, xen-devel@lists.xensource.com,
        Dave Jiang <dave.jiang@intel.com>,
        pkg-xen-devel@lists.alioth.debian.org,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        linux-kernel@vger.kernel.org, William Dauchy <wdauchy@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: ioatdma: Boot process hangs then reboots when using Xen + Linux
 3.2
Message-ID: <20120311220648.GA8120@burratino>
References: <20120302055715.GA692@burratino>
 <CABE8wwt8Lngy=-iL7QGCofy0nW5-q4VJDS_ovEr96fGdYm72ew@mail.gmail.com>
 <20120302162159.GB31683@wavehammer.waldi.eu.org>
 <CABE8wwtrMEAMw3sJgb8XWQWn_N=YOPzhNbLL0kzMKLhv7xt5=A@mail.gmail.com>
 <20120302175719.GA1468@wavehammer.waldi.eu.org>
 <CABE8wwvd-R1VkyFL-eZYDB9O05zyWkVQ8pXuMb8GcdAW=5qT3A@mail.gmail.com>
 <4F54DB1F.3080000@debian.org>
 <CABE8wwtOwgiYwb-_g-3Fg_QH6ph7LEPdkcOff94inDFvs9kwxA@mail.gmail.com>
 <4F55D6F6.2040906@debian.org>
 <CABE8wwsPA2PUx45EbY3w3BAHaHbUMWo7+giK=uU8gx9mbBkRpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABE8wwsPA2PUx45EbY3w3BAHaHbUMWo7+giK=uU8gx9mbBkRpQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Dan Williams wrote:

> Before you had mentioned that non-xen 32-bit builds don't fail.  Can
> you send me the .config from those two cases (offlist if they are too
> large)?

The failing and non-failing kernels are identical.  It is the
environment in which they are run that is different.

Running the kernel on bare metal works fine, while booting as a dom0
from the xen hypervisor triggers the assertion failure.[1]

.config: [2]

Hope that helps,
Jonathan

[1] http://thread.gmane.org/gmane.comp.emulators.xen.devel/121604/focus=121615
[2] http://alioth.debian.org/~jrnieder-guest/temp/config-3.2.0-2-686-pae
