Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab2HFNox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:44:53 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:50497 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab2HFNow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:44:52 -0400
From: Nix <nix@esperi.org.uk>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jerome Glisse <j.glisse@gmail.com>,
        alex.deucher@gmail.com
Subject: Re: [3.5 regression] DRM: Massive (EDID-probing?) X startup delay on ATI Radeon RV770 (HD4870)
References: <878vdumy99.fsf@spindle.srvr.nix>
	<CADnq5_O3agchGGGGX0Ozei9F4SMsM+mMRfw=F03Ux8QzZd4CQA@mail.gmail.com>
Emacs: Our Lady of Perpetual Garbage Collection
Date: Mon, 06 Aug 2012 14:44:49 +0100
In-Reply-To: <CADnq5_O3agchGGGGX0Ozei9F4SMsM+mMRfw=F03Ux8QzZd4CQA@mail.gmail.com>
	(Alex Deucher's message of "Mon, 6 Aug 2012 09:42:03 -0400")
Message-ID: <873940kucu.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-dcc1.aftenposten.no-Metrics: spindle 1215; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Aug 2012, Alex Deucher outgrape:

> On Sat, Aug 4, 2012 at 12:13 PM, Nix <nix@esperi.org.uk> wrote:
>> Something appears to be wrong, but I have no idea what. I've not changed
>> anything other than the kernel since my last non-huge-delayed startup
>> earlier this week, and both the monitors still work, including the one
>> suffering a huge startup delay.
>
> Can you bisect the kernel or profile Xorg and see what's causing it?
> There haven't been any i2c changes in the radeon kernel driver in a
> while.  I'm assuming it's only the kernel that you changed?  E.g.,
> just to be sure, does booting a different kernel with the same
> userspace components work correctly?

I believe so (I hadn't upgraded anything for a week or so before the
kernel upgrade). I'll verify this soon, and bisect in the next day or
so if the kernel is the only changed component.

-- 
NULL && (void)
