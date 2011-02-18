Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab1BRVnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 16:43:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51399 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab1BRVmy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 16:42:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=L49gy3B9Q8MfajRbOLA5F8cYCv5AGn8EpYBXaXj761aZVzhtbikS4RMvp8/TL5bkav
         F/Ln9thjeOMirIHOfNnFr71n+jtekMhZ8+IMzo21dmwbq4oQx8pNrAZZlmFC+ief37xs
         J3jSY83SaTsiNhuaL3Qr4wTA7ikbVXGQ1SRJk=
MIME-Version: 1.0
In-Reply-To: <1298062040-2774-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20110216200734.GA25184@merkur.ravnborg.org> <1298062040-2774-1-git-send-email-u.kleine-koenig@pengutronix.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 18 Feb 2011 16:42:34 -0500
Message-ID: <AANLkTinNT05b4YNdTvUF3jRqA=zob7KPT1_Vcic5vxQh@mail.gmail.com>
Subject: Re: [PATCH] kbuild: reenable section mismatch analysis
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/18 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> This was disabled in commit
>
>        e5f95c8 (kbuild: print only total number of section mismatces found)
>
> because there were too many warnings.  Now we're down to a reasonable
> number again, so we start scaring people with the details.

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
