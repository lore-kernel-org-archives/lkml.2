Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab2ALFeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 00:34:19 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64132 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2ALFeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 00:34:17 -0500
MIME-Version: 1.0
In-Reply-To: <20120111103408.30cfa338@jbarnes-desktop>
References: <20120111103408.30cfa338@jbarnes-desktop>
Date: Wed, 11 Jan 2012 21:34:14 -0800
X-Google-Sender-Auth: yBAdM4qRltlN7n1e7_kZ3B4wDng
Message-ID: <CAE9FiQVXaABZvjFdmkcu9kKtwTTaAqyE2Q0HZm5nOJPrieU8eg@mail.gmail.com>
Subject: Re: [git pull] PCI changes
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 10:34 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> The following changes since commit
> f423fc627b05f47bc9305f9661630fce30f208f9:
>
>  Revert "rtc: Expire alarms after the time is set." (2012-01-04 07:57:22 -0800)
>
> are available in the git repository at:
>  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci linux-next
>
> There's a fix pending for a build problem when CONFIG_AMD_NB=n, but I
> didn't want to delay the pull request any longer; I'll include it in
> the next fixes pull.
>
> This one doesn't include Yinghai's resource management stuff either,
> I'll put that in my -next tree for the next merge window when Yinghai
> has it ready.  That might be a good time to revert 12c22d6ef299 (the
> revert of the transparent bridge sizing code we talked about), unless
> you want to try it now.

Can you please push following patch to linus in this merging window?

https://lkml.org/lkml/2011/11/23/2

[PATCH -v4] PCI: Make sriov work with hotplug remove

Thanks

Yinghai
