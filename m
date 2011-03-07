Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab1CGJWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 04:22:25 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56386 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab1CGJWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 04:22:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=dMvok1aOu0XUG78INYIRE3gVnUvxcRoDcF3Pa7neY5sBgkvpdiyUC+cIQaGUeS0csd
         mN87DqHV3+7jS54UL/VP+X4bdBRT4f82ge1hWfvh/MLBoQIZi8qck0EBoMOqXIAY1p7O
         PqrT+1khAptijfwR5zkD5RvAbmqXLuDCm78AY=
MIME-Version: 1.0
In-Reply-To: <1299343345-3984-9-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
	<1299343345-3984-9-git-send-email-cesarb@cesarb.net>
Date: Mon, 7 Mar 2011 11:22:23 +0200
X-Google-Sender-Auth: V-qr_N7HE4yZWAVULJtjo96VZ4M
Message-ID: <AANLkTi=XHOg_oqCoMPw=m9SkJucQAfJ0bB+kQ14Rs_QF@mail.gmail.com>
Subject: Re: [PATCHv2 08/24] sys_swapon: move setting of error nearer use
From: Pekka Enberg <penberg@kernel.org>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 5, 2011 at 6:42 PM, Cesar Eduardo Barros <cesarb@cesarb.net> wrote:
> Move the setting of the error variable nearer the goto in a few places.
>
> Avoids calling PTR_ERR() if not IS_ERR() in two places, and makes the
> error condition more explicit in two other places.
>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> Tested-by: Eric B Munson <emunson@mgebm.net>
> Acked-by: Eric B Munson <emunson@mgebm.net>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
