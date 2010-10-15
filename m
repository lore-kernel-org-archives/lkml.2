Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab0JOXyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 19:54:52 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38417 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab0JOXyu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 19:54:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=qmUtb0/MKjiza7R5m/0vW8NrHoTdK3Chr0gX7yIgsRcbyBsfcOkv6oVCcaQyn6qSgn
         3LCAWZ9slDZqqEuu6QjVX+1Rn9UzIMUEiXdIKCNYoCYYk8z2jug25VGgSuIpHc+TvnWe
         ESciMwzk3ZOVBZ6usCnm3Ly2aWMkglO66XFTw=
MIME-Version: 1.0
In-Reply-To: <201010160036.17653.rjw@sisk.pl>
References: <201010160036.17653.rjw@sisk.pl>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 15 Oct 2010 16:54:29 -0700
X-Google-Sender-Auth: -H7qGeJGDEIb2k4xIp9E6cvGGwM
Message-ID: <AANLkTimdatos1psRnp_Es=q8iOe9aQE_aVARLpm18efb@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Convert to new PCI PM framework
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 3:36 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> The ath9k driver uses the legacy PCI power management (suspend
> and resume) callbacks that apparently cause intermittent problems
> to happen (the adapter sometimes doesn't resume correctly on my
> Acer Ferrari One).  Make it use the new PCI PM and let the PCI core
> code handle the PCI-specific details of power transitions.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Do you know when these hooks were added? If it fixes an issue should
this go for stable?

 Luis
