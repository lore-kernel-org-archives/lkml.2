Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab1CERZz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:25:55 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63269 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab1CERZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:25:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=i3Uj7z2kZiz5PUWdIFk2+ev2rC79jSivHtlACfisqzbzgAg5aMkujp5Jzq11LHh+eQ
         7nUI2zFy1ZZCMDKvaLP7ueby95m2qMVObuauYF+yFUr9MS0ujHOa6eSMsOxyf8Dm8xGw
         OJIlcmU+U2mgULEbl2arQXbZ8rH4WduJbSnYM=
MIME-Version: 1.0
In-Reply-To: <1299343345-3984-20-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
	<1299343345-3984-20-git-send-email-cesarb@cesarb.net>
Date: Sat, 5 Mar 2011 19:25:53 +0200
X-Google-Sender-Auth: Irhn3UndvLqZgqrDzop2TLjD-bo
Message-ID: <AANLkTikcu-CTDWQxpjBn4JcERbo30DGRho=q3hyMdbS1@mail.gmail.com>
Subject: Re: [PATCHv2 19/24] sys_swapon: separate parsing of bad blocks and extents
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
> Move the code which parses the bad block list and the extents to a
> separate function. Only code movement, no functional changes.
>
> This change uses the fact that, after the success path, nr_good_pages ==
> p->pages.
>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> Tested-by: Eric B Munson <emunson@mgebm.net>
> Acked-by: Eric B Munson <emunson@mgebm.net>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
