Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab0KJCHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 21:07:42 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64160 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab0KJCHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 21:07:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FwGTlCpjmoKOFn3xI/uXQO1Ca/8T4G7FicLDYNHqSohYQd6+KgmvAeLpQBgvioVBkg
         9z/yVqYSNwReeYVCa+JtW56Sg4VwdHh/sKaTlmRok+HRZy3PujBk5vCLe9dNWnG+Xmif
         1z/eWWzlu5G1hLw4EtVyNfBp0Jra4DaDJ8Z3k=
Message-ID: <4CD9FE64.5010600@gmail.com>
Date: Tue, 09 Nov 2010 21:07:32 -0500
From: Richard Farina <sidhayn@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US; rv:1.8.1.6) Gecko/20070728 Thunderbird/2.0.0.6 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Compat-wireless for 2.6.37-rc1 - 802.11, Bluetooth and Ethernet
 backported
References: <AANLkTimz=0MknJnivvEb_Uq4fjDWFDUN5ug=kOo+eocd@mail.gmail.com>
In-Reply-To: <AANLkTimz=0MknJnivvEb_Uq4fjDWFDUN5ug=kOo+eocd@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> Linus released 2.6.37-rc1 a couple of weeks ago and we now have our
> first vanilla release for the same kernel. This is a stable  [1]
> compat-wireless-2.6.36-rc7-1 [2], this release has no extra patches
> applied on top and at this point I am a bit lazy to go ahead and suck
> these in so please note you'll likely end up with a lot of stable
> patches missing but I will hope that in the next linux-next.git these
> get sucked in and I can simply use ./scripts/admin-updates.sh -s to
> suck them in for the rc2 release.
>
> Please report any issues ASAP but be-aware there are a few stable
> patches missing still. I'd trust the compat-wireless-2.6.36-5-spn
> right now more if you are looking for something really stable, but I
> do expect this release to stabilize after a couple of RCs. For details
> on changes you can refer to the now very highly detailed
> ChangeLog-2.6.37-rc1-wireless [3] which includes the changes for
> compat.git, compat-wireless.git and the Linux kernel for the
> backported subsystems.
>
> Origin remote URL:
> git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-allstable.git
> This is a stable compat-wireless release
>
> compat-wireless code metrics
>
>     739355 - Total upstream lines of code being pulled
>       2163 - backport code changes
>       1909 - backport code additions
>        254 - backport code deletions
>       6324 - backport from compat module
>       8487 - total backport code
>     1.1479 - % of code consists of backport work
>
> Base tree: linux-2.6-allstable.git
> Base tree version: v2.6.37-rc1
> compat-wireless release: compat-wireless-v2.6.37-rc1-1
>
> Cleaning up the release ...
> Creating compat-wireless-2.6.37-rc1-1.tar.bz2 ...
>
> Compat-wireles release: compat-wireless-2.6.37-rc1-1
> Size: 3.7M	compat-wireless-2.6.37-rc1-1.tar.bz2
> sha1sum: 60b1c6e9d421f039e22b62901de816a46931a603
> compat-wireless-2.6.37-rc1-1.tar.bz2
>
>   
http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/compat-wireless-2.6.37-1.tar.bz2
The filename on the website has no -rc, please fix as this will 
definitely cause confusion.

Thanks,
Rick Farina
>   Luis
>
> [1] http://wireless.kernel.org/en/users/Download/stable
> [2] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/compat-wireless-2.6.37-1.tar.bz2
> [3] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/ChangeLog-2.6.37-wireless
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   

