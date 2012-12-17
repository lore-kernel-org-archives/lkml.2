Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab2LQQxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 11:53:06 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34377 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab2LQQxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 11:53:05 -0500
MIME-Version: 1.0
In-Reply-To: <20121217140238.GA626@gmail.com>
References: <50CB3EAB.309@itwm.fraunhofer.de>
	<CAE9FiQVFSx7sJhYbREk+gfdgxO6uMgHWdDv1tbkU=VXqfH4iAg@mail.gmail.com>
	<CAE9FiQUyj65jB4bPkJQHGRZEkhOry736g362-m145vNYRRSdAQ@mail.gmail.com>
	<50CE0C82.20708@itwm.fraunhofer.de>
	<CAE9FiQUJ-TZCCOki3XfMOgOvOL=TiApJGQdHcHNAPmYKRtVk6A@mail.gmail.com>
	<50CEE586.10800@itwm.fraunhofer.de>
	<20121217140238.GA626@gmail.com>
Date: Mon, 17 Dec 2012 08:53:00 -0800
X-Google-Sender-Auth: H35Gdu1BLqQP1gOzLuEaZ2tqGKc
Message-ID: <CAE9FiQWHMMCSdrSAyf-aBKV5xmj4XAcyD0R7Mi1qN40XqE3ROQ@mail.gmail.com>
Subject: Re: [regression] 3.7 ends in APIC panic
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 6:02 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> I suspect this needs to be fixed/improved: currently it's way
> too easy to disable x2apic support accidentally.
>

We can just enable x2apic by default when CONFIG_EMBEDDED is not set.
