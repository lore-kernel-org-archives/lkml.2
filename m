Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab2CVTpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 15:45:05 -0400
Received: from hulk.biessmann.org ([62.75.166.25]:49137 "EHLO
	hulk.biessmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab2CVTpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 15:45:03 -0400
Message-ID: <4F6B8118.2040608@biessmann.de>
Date: Thu, 22 Mar 2012 20:44:24 +0100
From: =?UTF-8?B?QW5kcmVhcyBCaWXDn21hbm4=?= <andreas@biessmann.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Michal Marek <mmarek@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86, build: remove unused include
References: <1329324589-26907-1-git-send-email-andreas@biessmann.de> <20120322101719.GC1406@localhost> <4F6B6FDB.80507@zytor.com>
In-Reply-To: <4F6B6FDB.80507@zytor.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SPAM_bar: --
X-SPAM_score: -28
X-ChkData-Signature: 23bd1d5842f53ef3d5fc24c81abd7368
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.03.12 19:30, H. Peter Anvin wrote:
> On 03/22/2012 03:17 AM, Andreas Bießmann wrote:
>> On Wed, Feb 15, 2012 at 05:49:49PM +0100, Andreas Bießmann wrote:
>>> Commit 079f85e624189292d1c818b47764916bf8cf84a8 removed necessity for
>>> sys/sysmacros.h include but missed to remove the include.

> An equivalent patch has been in tip:x86/build for a while and was just
> pulled upstream by Linus.

sorry for the noise, I did only search for my patch in history and did
not check the file.

regards

Andreas Bießmann
