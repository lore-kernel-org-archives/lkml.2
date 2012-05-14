Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab2ENSDC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:03:02 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53063 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364Ab2ENSDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:03:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120514171702.GC21960@aftab.osrc.amd.com>
References: <cover.1336674796.git.tony.luck@intel.com>
	<e6fa674d2f4ded80201f733d06b234b21559f0fe.1336674796.git.tony.luck@intel.com>
	<20120513095913.GB28863@aftab.osrc.amd.com>
	<3908561D78D1C84285E8C5FCA982C28F192EED2B@ORSMSX104.amr.corp.intel.com>
	<20120514171702.GC21960@aftab.osrc.amd.com>
Date: Mon, 14 May 2012 11:02:59 -0700
X-Google-Sender-Auth: p8h3nIDJwX9MkNmrT-GmORe4z4Q
Message-ID: <CA+8MBbKr-dc2MFNCvthqWzy3MvQmb8UEKy74mi36BkYHLDTOPg@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86/mce: Only restart instruction after machine check
 recovery if it is safe
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 10:17 AM, Borislav Petkov <bp@amd64.org> wrote:
> I was wondering about that but don't have any other flags/use cases.
> Well, we can always change it later if needed.

So is that an Ack? I was thinking that I should send this part to
Linus now ... since restarting from a fault when RIPV isn't set
could result in an application doing something bad (like getting
the wrong answer).

The instruction stuff is new and needs to wait for the merge window.

-Tony
