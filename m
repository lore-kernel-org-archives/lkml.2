Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab0KOBRq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 20:17:46 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34167 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab0KOBRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 20:17:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=twOkVQF2q44iC5tn/zpFOpeY1fANXQWPXvYCSSwdSNNFEkXC8JIVhhvw2bq0bUYVb+
         MR8LmVF0U2zpHTgOh6JWnTa6LnGIAUxXR9xd0cQP7vuFCpqYbyOvjtF6g6m8eOgz5YW8
         wCR0TQhboG0EqrPFF7OP69Pda2B29gK1FW13E=
From: Ben Gamari <bgamari@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, libcg-devel@lists.sourceforge.net
Subject: Re: Mounting blkio cgroup hierarchy
In-Reply-To: <4CE083A4.4030206@cn.fujitsu.com>
References: <87fwv6sbwr.fsf@gmail.com> <4CE083A4.4030206@cn.fujitsu.com>
User-Agent: Notmuch/0.5-3-g22aadfc (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Sun, 14 Nov 2010 20:17:39 -0500
Message-ID: <87eiancrm4.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010 08:49:40 +0800, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Ben Gamari wrote:
> > I've been trying to configure cgroups and have encountered some very
> > strange behavior. In particular, when I follow the instructions in
> > Documentation/cgroups/blkio-controller.txt I quickly reach an error,
> > 
> > $ cd /mnt
> > $ sudo mkdir -p cgroups/blkio
> > $ # Confirm it's not already mounted:
> > $ cat /proc/mounts
> > $ sudo mount -t cgroup -o blkio none /mnt/cgroups/blkio
> ...
> > mount: special device none does not exist
> > 
> > I've done quite a bit of Googling and yet it's very difficult to find
> > good information on configuring cgroups. I would use the libcg
> > toolset[1] but every attempt to configure it has ended in frustratingly
> > vague error messages.
> > 
> > Any ideas?
> > 
> 
> I suspect you didn't have blkio enabled in your kernel config.
> 
Doh! I could have sworn I had enabled this. Sorry for the noise!

- Ben
