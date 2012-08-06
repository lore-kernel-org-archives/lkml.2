Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab2HFNZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:25:39 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:54694 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab2HFNZi (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:2>);
	Mon, 6 Aug 2012 09:25:38 -0400
Message-Id: <501FE1ED0200007800092DF0@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 06 Aug 2012 14:25:33 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "=?UTF-8?B?SsOpcsO0bWVDYXJyZXRlcm8=?=" <cJ-ko@zougloub.eu>
Cc: "Ingo Molnar" <mingo@kernel.org>,
        "Matt Fleming" <matt.fleming@linux.intel.com>,
        "Matthew Garrett" <mjg59@srcf.ucam.org>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "H. PeterAnvin" <hpa@zytor.com>
Subject: Re: [Regression] "x86-64/efi: Use EFI to deal with platform
 wall clock" prevents my machine from booting
References: <20120805172903.5f8bb24c@zougloub.eu>
 <501EF3A2.20200@zytor.com> <501F83F20200007800092C1C@nat28.tlf.novell.com>
 <20120806125216.GA11863@srcf.ucam.org>
 <501FDDD30200007800092DDE@nat28.tlf.novell.com>
 <20120806091627.2ad5ed2e@zougloub.eu>
In-Reply-To: <20120806091627.2ad5ed2e@zougloub.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.08.12 at 15:16, JérômeCarretero <cJ-ko@zougloub.eu> wrote:
> If it helps:
> 
> - I can bisect the patch further down (might be a bit silly because
>   I don't quite understand it),
> - you can suggest some modifications and at least I can test them

What would help most would be the full kernel log up to the crash,
including the register and stack dumps that are presumably there.
Without that there's nothing I can suggest.

Jan
