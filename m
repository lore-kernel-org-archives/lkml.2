Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab1GKLcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 07:32:00 -0400
Received: from smtp.turknetserver.com ([193.192.122.40]:52577 "EHLO
	smtp.turknetserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab1GKLb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 07:31:59 -0400
Message-ID: <4E1ADF26.10605@turknetserver.com>
Date: Mon, 11 Jul 2011 14:31:50 +0300
From: Tarkan Erimer <tarkan@turknetserver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] btrfs fixes
References: <1310151138-sup-6548@shiny>
In-Reply-To: <1310151138-sup-6548@shiny>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2011 09:55 PM, Chris Mason wrote:
> Hi everyone,
>
> The for-linus branch of the btrfs-unstable repo:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus
>
> Has three more fixes.  We're fixing oopsen during space balancing (btrfs
> filesystem balance /mnt)) and during device removal.
>
> Dave Sterba also sent in a patch to make /proc/mounts properly match a
> few new mount options, which he (correctly I think) considers a
> regression fix because it makes it hard for testers/users to verify the
> options in a running config.
>

Hi Chris,

Maybe, any development regarding to the "[BUG] Btrfs: Corrupted root 
filesystem" subjected bug posted by me ?


Tarkan
