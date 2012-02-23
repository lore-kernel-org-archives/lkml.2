Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab2BWG2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 01:28:51 -0500
Received: from hulk.biessmann.org ([62.75.166.25]:54195 "EHLO
	hulk.biessmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab2BWG2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 01:28:50 -0500
Message-ID: <4F45DC99.1050405@biessmann.de>
Date: Thu, 23 Feb 2012 07:28:41 +0100
From: =?UTF-8?B?QW5kcmVhcyBCaWXDn21hbm4=?= <andreas@biessmann.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: =?UTF-8?B?QW5kcmVhcyBCaWXDn21hbm4=?= <andreas@biessmann.de>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Jochen Friedrich <jochen@scram.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: Re: [PATCH] mod/file2alias: make modpost compile on darwin again
References: <1329947735-4331-1-git-send-email-andreas@biessmann.de> <874nui5uv2.fsf@rustcorp.com.au>
In-Reply-To: <874nui5uv2.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SPAM_bar: --
X-SPAM_score: -28
X-ChkData-Signature: d7728f4bf4f79dc40812083b19a5dfae
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 23.02.12 00:08, Rusty Russell wrote:
> On Wed, 22 Feb 2012 22:55:35 +0100, Andreas Bießmann <andreas@biessmann.de> wrote:
>> commit e49ce14150c64b29a8dd211df785576fa19a9858 breaks cross compiling
>> the linux kernel on darwin hosts.
>> This fix introduce some minimal glue to adopt linker section handling
>> for darwin hosts.
> 
> Really?

Yes.

> Yes, I assumed an ELF host.  There's a portable way of doing this, but
> it's damn ugly (see http://ccodearchive.net/info/autodata.html).

I stumbled over some other code snippet [1] when searching for a solution.

> Oh, and checkpatch.pl is wrong, the code was fine.

Sorry for that. I was running checkpatch.pl as dutiful patch submitter
and that complained. Should I provide another version with 'checkpatch'
adoptions changed back?

> If noone has strong opinions about this, I'll apply it.

Would be great. I guess this is a rare case (cross compiling on darwin
host) but at least I and some of my colleagues do it from time to time.

Andreas
--
[1]
http://google-perftools.googlecode.com/svn/!svn/bc/48/trunk/src/base/basictypes.h
