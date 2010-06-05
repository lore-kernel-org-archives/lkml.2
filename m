Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933341Ab0FENAE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 09:00:04 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:63180 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933311Ab0FENAB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 09:00:01 -0400
X-AuditID: 1209190f-b7b20ae000003f85-82-4c0a4a50bf21
Subject: Re: [TuxOnIce-devel] [SUSPECTED SPAM] Re: [linux-pm] Proposal for a new algorithm for reading & writing a hibernation image.
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <4C0994B9.6070406@crca.org.au>
Date: Sat, 5 Jun 2010 08:59:53 -0400
Cc: Pavel Machek <pavel@ucw.cz>, pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <88D03BC9-5E85-482D-9431-F1CE4C958C9B@mit.edu>
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com> <4C0994B9.6070406@crca.org.au>
To: Nigel Cunningham <ncunningham@crca.org.au>
X-Mailer: Apple Mail (2.1078)
X-Brightmail-Tracker: AAAAARSDVRc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 4, 2010, at 8:05 PM, Nigel Cunningham wrote:
>> 2mb pages will probably present a problem, as will bat mappings on powerpc.
> 
> I have the idea that 2MB pages are only used for the kernel text and read only data. Is that right? If so, perhaps they can just be unconditionally copied (so that we can restore the image if a different kernel is booted) and wouldn't need any page protection. Does that sound right?

No, hugepages are available for use by userspace programs.  

See: https://lwn.net/Articles/374424/

- Ted

