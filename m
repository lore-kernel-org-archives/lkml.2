Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab1BMKvG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 05:51:06 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47682 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab1BMKu5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 05:50:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=fDaiIadavDjX7FXe22oKsxg6L83K3xEwyuTd50WYGFreBwNrC0IMHOo5qQKvAmt+Cf
         HZSv1uwCkdilGhJ3riY7GrGA3+FR4b4VDO/W/E6xSTUegZeNvkBJAPTfJS8rq/bGuvUP
         ZcmV2hWvtxcztbSsqSn+92rTSOGmYgilL33RU=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <NMZS1i37KEE.A.1eG.6_wVNB@chimera>
References: <NMZS1i37KEE.A.1eG.6_wVNB@chimera>
Date: Sun, 13 Feb 2011 11:50:56 +0100
Message-ID: <AANLkTi=RnAgp47OTTk_JaNG79ZTb9nQJwLgJfAH4ip+J@mail.gmail.com>
Subject: Re: 2.6.38-rc4-git5: Reported regressions from 2.6.37
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Felix Fietkau <nbd@openwrt.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 12, 2011 at 11:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message contains a list of some regressions from 2.6.37,
> for which there are no fixes in the mainline known to the tracking team.
> If any of them have been fixed already, please let us know.
>
> If you know of any other unresolved regressions from 2.6.37, please let us
> know either and we'll add them to the list.  Also, please let us know
> if any of the entries below are invalid.
>
> Each entry from the list will be sent additionally in an automatic reply
> to this message with CCs to the people involved in reporting and handling
> the issue.
>
>
> Listed regressions statistics:
>
>  Date          Total  Pending  Unresolved
>  ----------------------------------------
>  2011-02-12       39       20          18
>  2011-02-03       19       11           7
>
>
> Unresolved regressions
> ----------------------

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=28442
> Subject         : 2.6.38-rc3: FUSE (sshfs) hangs under load
> Submitter       : Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Date            : 2011-02-01 17:54 (12 days old)
> First-Bad-Commit: http://git.kernel.org/linus/4cd06a344db752f513437138953af191cbe9a691
> Message-ID      : <20110201175452.GB518@core.coreip.homeip.net>
> References      : http://marc.info/?l=linux-kernel&m=129658291703679&w=2
>

The fix by Felix [1] was accepted already in Linus tree:

commit fc7c976dc7a565213393ce700d4a6105f037bf20
"mac80211: fix the skb cloned check in the tx path"

Please, remove the entry from the list, Thanks.

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=fc7c976dc7a565213393ce700d4a6105f037bf20
