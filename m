Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab1DLHMC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 03:12:02 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:35742 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab1DLHMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 03:12:00 -0400
Subject: Re: [PATCH 09/34] x86: Allow to override the ROOT_DEV variable
From: Paul Bolle <pebolle@tiscali.nl>
To: Valdis.Kletnieks@vt.edu
Cc: Michal Marek <mmarek@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
In-Reply-To: <17983.1302578741@localhost>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
	 <1302015561-21047-10-git-send-email-mmarek@suse.cz>
	 <4D9B3581.6080105@zytor.com> <4D9C1AA0.9030008@suse.cz>
	 <20110411150820.GA22004@sepie.suse.cz>  <17983.1302578741@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 09:11:50 +0200
Message-ID: <1302592310.26451.16.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-11 at 23:25 -0400, Valdis.Kletnieks@vt.edu wrote:

> Does the default of FLOPPY still get used after this patch, or is this a stale comment?

It looks like a stale comment to me. The default currently actually is
0, 0 (major, minor). I'm not sure "FLOPPY" even works. Is
'stat("FLOPPY", ...)' legal?

> Also, I sort of expected to see more code removed that *used* the no-longer-passed
> value of ROOT_DEV.

That's what I expect too. See my addendum to Michal's patch in the
message I sent a few hours ago.


Paul Bolle

