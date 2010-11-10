Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab0KJWs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:48:27 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42720 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab0KJWsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:48:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=l6krxa5keYQfLUDq0EAuSuCapaC7DHz1A3Jq2ui1OsA6nm/8GQxhhCwepKnyHSbBlo
         WKoGkYpTnY3IL7D8jBZHIQ19OJy0qqjT7NAF1yjUhgTY3QCE7bTJp7VBkqgGZ5ojFjEW
         3DIZlsPwpUBRA5h0V2wO8wsg3kqt5I5ESNsCI=
MIME-Version: 1.0
In-Reply-To: <cover.1289348757.git.joe@perches.com>
References: <cover.1289348757.git.joe@perches.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 10 Nov 2010 14:48:02 -0800
Message-ID: <AANLkTinhcbdm8YQOrFVdONODo6K6PcxHYtx5vqnap_3T@mail.gmail.com>
Subject: Re: [PATCH 0/9] treewide: convert vprintk uses to %pV
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        cluster-devel@redhat.com, linux-nilfs@vger.kernel.org,
        linux-nfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 4:35 PM, Joe Perches <joe@perches.com> wrote:
> Multiple secessive calls to printk can be interleaved.
> Avoid this possible interleaving by using %pV
>
> Joe Perches (9):
>  drivers/gpu/drm/drm_stub.c: Use printf extension %pV
>  drivers/isdn/mISDN: Use printf extension %pV
>  drivers/net/wireless/ath/debug.c: Use printf extension %pV
>  drivers/net/wireless/b43/main.c: Use printf extension %pV
>  drivers/net/wireless/b43legacy/main.c: Use printf extension %pV
>  fs/gfs2/glock.c: Use printf extension %pV
>  fs/nilfs2/super.c: Use printf extension %pV
>  fs/quota/dquot.c: Use printf extension %pV
>  net/sunrpc/svc.c: Use printf extension %pV
>
>  drivers/gpu/drm/drm_stub.c            |   14 +++++++--
>  drivers/isdn/mISDN/layer1.c           |   10 +++++--
>  drivers/isdn/mISDN/layer2.c           |   12 ++++++--
>  drivers/isdn/mISDN/tei.c              |   23 +++++++++++----
>  drivers/net/wireless/ath/debug.c      |    9 +++++-
>  drivers/net/wireless/b43/main.c       |   48 ++++++++++++++++++++++++--------
>  drivers/net/wireless/b43legacy/main.c |   47 ++++++++++++++++++++++++--------
>  fs/gfs2/glock.c                       |    9 +++++-
>  fs/nilfs2/super.c                     |   23 +++++++++++-----
>  fs/quota/dquot.c                      |   12 +++++---
>  net/sunrpc/svc.c                      |   12 +++++---
>  11 files changed, 161 insertions(+), 58 deletions(-)

When was this added upstream BTW? I ask for backport considerations.

  Luis
