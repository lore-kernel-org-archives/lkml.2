Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558Ab0I0BAy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 21:00:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63780 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab0I0BAx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 21:00:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZoaXAQGQTjDoyAUCZhkXb7uopuBaTvhtpwRxpnx/zyi44Qxz76IYwyepMhzSQgsSO3
         mszoIKnbSwRpIIIxodp09BkYXg7sVNYe5YkteYa/T0tQXhxq/A7rQseg1uahgZUnveK3
         fdEx4KNmSKk/8QhuVDCyctwbgJPRIKz+7M6Uk=
MIME-Version: 1.0
In-Reply-To: <20100927003608.GA20395@kroah.com>
References: <20100927003608.GA20395@kroah.com>
Date: Mon, 27 Sep 2010 04:00:51 +0300
Message-ID: <AANLkTikHtuXhMtjudLTUMPR7uL9eGGePUP93MqFLTfb5@mail.gmail.com>
Subject: Re: Linux 2.6.35.6
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 27, 2010 at 3:36 AM, Greg KH <gregkh@suse.de> wrote:
> I'm announcing the release of the 2.6.35.6 kernel.
>
> All users of the 2.6.35 kernel series must upgrade.
>
> The updated 2.6.35.y git tree can be found at:
>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.35.y.git
> and can be browsed at the normal kernel.org git web browser:
>        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.35.y.git;a=summary

I usually do 'git fetch' to get new changes in all my repos, however,
this one seems to be a bit different; there's no branch. Since there's
no branch, 'git fetch' doesn't retrieve the tags.

Can you add a 'master' branch that points to the latest tag? That
would make things easier for other people, specially the ones that
just do 'git pull'.

Cheers.

-- 
Felipe Contreras
