Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab2HFNPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:15:38 -0400
Received: from zougloub.eu ([188.165.233.99]:36276 "EHLO zougloub.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756213Ab2HFNPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:15:37 -0400
Date: Mon, 6 Aug 2012 09:16:27 -0400
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>, "Ingo Molnar" <mingo@kernel.org>,
        "Matt Fleming" <matt.fleming@linux.intel.com>,
        <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Regression] "x86-64/efi: Use EFI to deal with platform wall
 clock" prevents my machine from booting
Message-ID: <20120806091627.2ad5ed2e@zougloub.eu>
In-Reply-To: <501FDDD30200007800092DDE@nat28.tlf.novell.com>
References: <20120805172903.5f8bb24c@zougloub.eu>
	<501EF3A2.20200@zytor.com>
	<501F83F20200007800092C1C@nat28.tlf.novell.com>
	<20120806125216.GA11863@srcf.ucam.org>
	<501FDDD30200007800092DDE@nat28.tlf.novell.com>
Organization: none
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Aug 2012 14:08:03 +0100
"Jan Beulich" <JBeulich@suse.com> wrote:

> with the change at hand I merely tried to be proactive).

Jan,

If it helps:

- I can bisect the patch further down (might be a bit silly because
  I don't quite understand it),
- you can suggest some modifications and at least I can test them

HTH,

-- 
cJ
