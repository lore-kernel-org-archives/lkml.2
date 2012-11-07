Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab2KGIjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 03:39:00 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58299 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab2KGIi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 03:38:57 -0500
MIME-Version: 1.0
In-Reply-To: <0678A2A4-F1BE-4A18-B3F2-ECCCAEEB1093@vulytrampolines.com>
References: <E3FFC807-CA31-45EA-A8EF-1266A27F9A0D@vulytrampolines.com>
	<CAFLxGvx_ASg3=dspS33ajsT5DJgNqsz2TmTY8b+k9BfmGhHXwg@mail.gmail.com>
	<0678A2A4-F1BE-4A18-B3F2-ECCCAEEB1093@vulytrampolines.com>
Date: Wed, 7 Nov 2012 09:38:56 +0100
Message-ID: <CAFLxGvzN1m1V2RDndD2vM+peHuoomuTMhQXab5UzTnq6aX3tyg@mail.gmail.com>
Subject: Re: Network routing problem after upgrading to 3.6.2
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Melby Sjamsuddin <melby.s@vulytrampolines.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 9:18 AM, Melby Sjamsuddin
<melby.s@vulytrampolines.com> wrote:
> Hi Richard,
>
> I tested 3.5.7 and everything seems to be normal, so it must be 3.6.
> Let me know if there's anything I can help.

Now you can do a git bisect between 3.5 and 3.6 to find the bad commit.
And you can report the issue (in detail!) to netdev@vger.kernel.org

-- 
Thanks,
//richard
