Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab2BZQ13 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 11:27:29 -0500
Received: from smtprelay05.ispgateway.de ([80.67.31.97]:57729 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab2BZQ12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 11:27:28 -0500
Message-ID: <4F4A5D6B.10102@bwalle.de>
Date: Sun, 26 Feb 2012 17:27:23 +0100
From: Bernhard Walle <bernhard@bwalle.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jochen Friedrich <jochen@scram.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        =?UTF-8?B?QW5kcmVhcyBCaWXDn21hbm4=?= <andreas@biessmann.de>
Subject: Re: [PATCH v2] mod/file2alias: make modpost compile on darwin again
References: <1329947735-4331-1-git-send-email-andreas@biessmann.de> <1330068233-12713-1-git-send-email-andreas@biessmann.de>
In-Reply-To: <1330068233-12713-1-git-send-email-andreas@biessmann.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Df-Sender: YmVybmhhcmRAYndhbGxlLmRl
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 24.02.12 08:23, schrieb Andreas Bießmann:
> commit e49ce14150c64b29a8dd211df785576fa19a9858 breaks cross compiling
> the linux kernel on darwin hosts.
> This fix introduce some minimal glue to adopt linker section handling
> for darwin hosts.
> 
> Signed-off-by: Andreas Bießmann <andreas@biessmann.de>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: Jochen Friedrich <jochen@scram.de>
> CC: Samuel Ortiz <sameo@linux.intel.com>
> CC: "K. Y. Srinivasan" <kys@microsoft.com>

Tested-by: Bernhard Walle <bernhard@bwalle.de>

Would be nice if that patch gets applied even if cross-compiling the
Linux kernel on a Mac is exotic.


Regards,
Bernhard
