Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab0LQKAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 05:00:46 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56752 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab0LQKAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 05:00:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=K19NMqiU75E2n+R3ZZtc6O+hCJVIRhygb15xgb+SIJ3hCk7L+doEZ6AMmwBU8IMR53
         JLdO+Bb0XnhuUuJJGFCsl7NLv5wpiU2QhgWJ0RUCzHs9wWPu6LPllYvysdyn6a2SHCiK
         c/l6lUKlARbUM+DyWj8bS+tKhM/ZjZ3x+vU7Q=
MIME-Version: 1.0
In-Reply-To: <20101217173237.fe1de00a.sfr@canb.auug.org.au>
References: <20101217173237.fe1de00a.sfr@canb.auug.org.au>
Date: Fri, 17 Dec 2010 12:00:43 +0200
Message-ID: <AANLkTinSOm9cK8LgUO4wm6NTsMsCcE9YyjcPyoSv=WJa@mail.gmail.com>
Subject: Re: linux-next: Tree for December 17
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 8:32 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> [The mirroring on kernel.org is running slowly]
>
> Changes since 20101216:
>
> The vfs-scale tree gained a conflict against the hfsplus tree.
>
> The wireless tree lost its build failure.
>
> The block tree gained a conflict against the scsi tree.
>
> The offending commit was removed from the rcu tree.
>
> The tty tree gained a build failure so I reverted a commit.
>
> The usb tree lost 3 conflicts.


next-20101216 works fine.

This version failed:
http://i53.tinypic.com/54vxgp.jpg
