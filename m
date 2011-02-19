Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab1BSPOy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 10:14:54 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54626 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab1BSPOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 10:14:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=d24A+3Rjlmz53+4cXxe9XbkPhN9W/mX1eCLgJntQswt2BHUKpfL+kGeuWaj6d92MMY
         ogPr9iwSyyB7BYIr38DwrbSD7KlGpwkQ0ZKgWC5Ad+mophDgOr7bdBfhf++F0PuseSOL
         JnvK3Qeo0D+QPH2G6+EEn0Ni8UgU1wQQKPVyE=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
Date: Sat, 19 Feb 2011 16:14:52 +0100
Message-ID: <AANLkTikBbwAmGmndye=0PKJS33Bt8YY5XVnTpjHecoTL@mail.gmail.com>
Subject: Re: [git pull] drm for rc1
From: Alex Riesen <raa.lkml@gmail.com>
To: Dave Airlie <airlied@linux.ie>, Chris Wright <chrisw@sous-sol.org>
Cc: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 23:59, Dave Airlie <airlied@linux.ie> wrote:
> The following changes since commit 989d873fc5b6a96695b97738dea8d9f02a60f8ab:
>
>  Merge master.kernel.org:/home/rmk/linux-2.6-arm (2011-01-03 16:37:01 -0800)
>
> are available in the git repository at:
>
>  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-core-next
>
...
>      drm/i915: Completely disable fence pipelining.

Reverting this commit helps in v2.6.38-rc5+ when screen is not fully updated,
or has a corrupted picture like horizontal black or white stripes. Using a
compositor like compiz may help to avoid the problem.

See bug https://bugzilla.kernel.org/show_bug.cgi?id=27572
