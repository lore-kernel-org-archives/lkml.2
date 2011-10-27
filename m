Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab1J0X2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 19:28:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47599 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab1J0X2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 19:28:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAH+fs=-WkbLgB-wsNEPS_OnvqwK9eChMCrMOudjtg7bu2ZtqHg@mail.gmail.com>
References: <CAH+fs=-WkbLgB-wsNEPS_OnvqwK9eChMCrMOudjtg7bu2ZtqHg@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 28 Oct 2011 01:28:24 +0200
Message-ID: <CAMjpGUcGS8yB2fdB_fG=MrUn8yrmfB31APirryhSQ7-fCXPg+A@mail.gmail.com>
Subject: Re: [PATCH]: expose FORCE_MAX_ZONEORDER on x86
To: Marc Leeman <marc.leeman@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 11:02, Marc Leeman <marc.leeman@gmail.com> wrote:
> Larger blocks of memory can be required for e.g. higher resolutions on
> some capture card drivers; this patch just enables an already
> available configuration option on x86 (it was already exposed on other
> architectures).

at this point, it sounds like maybe we should make it available to
everyone.  perhaps under the embedded/expert/whatever-it's-called-now
sub-menu.
-mike
