Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab1CERHN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:07:13 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61313 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab1CERHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:07:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=qofj4uHNi5u1HX9lp7tgLp1ZCdY1pRihG75UGSnGpXtQNcIqfCZYU2g8VmCdpEMz2T
         nIbBlzOdcKNGGyf+9DLH5/xLspJmeIcgxo+puK0CO3SQjZeFYv8Dz3od1njB/xqcFpFH
         YkAJiwj9lXukHudtcEr+H2udELXMNaREcx2Jg=
MIME-Version: 1.0
In-Reply-To: <1299343345-3984-4-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
	<1299343345-3984-4-git-send-email-cesarb@cesarb.net>
Date: Sat, 5 Mar 2011 19:07:11 +0200
X-Google-Sender-Auth: JnKOd1NGmj_0Hgvx6bAu5kFAw3g
Message-ID: <AANLkTin3EWz4g_y03M7TOzAmD+wYJkR3a-cOJOy4ru07@mail.gmail.com>
Subject: Re: [PATCHv2 03/24] sys_swapon: do not depend on "type" after allocation
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
> Within sys_swapon, after the swap_info entry has been allocated, we
> always have type == p->type and swap_info[type] == p. Use this fact to
> reduce the dependency on the "type" local variable within the function,
> as a preparation to move the allocation of the swap_info entry to a
> separate function.
>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> Tested-by: Eric B Munson <emunson@mgebm.net>
> Acked-by: Eric B Munson <emunson@mgebm.net>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
