Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1CERL2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:11:28 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43905 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab1CERL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:11:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=b7egMMTc9svHdeM1tGr50i7+7f/SgTCcH7OIAqXvFbtRxP+eNGW6p9Vsuw0btO5n0n
         xQOK/a8nkt8JS7kQbsToqI91tzAT1QieBBOVOWo/9oda+2RrmKS5m4xlNkCncanFrILI
         zj8+Yho/LoP+eDjje+knz4aY/g8HbkN3XpXHo=
MIME-Version: 1.0
In-Reply-To: <1299343345-3984-8-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
	<1299343345-3984-8-git-send-email-cesarb@cesarb.net>
Date: Sat, 5 Mar 2011 19:11:26 +0200
X-Google-Sender-Auth: wBP2Nl9uFrizEvvnjv4-GhmFvWs
Message-ID: <AANLkTi=cP38uTMx922enrzz_q9-Zy3Vp8_uiQx47dzDS@mail.gmail.com>
Subject: Re: [PATCHv2 07/24] sys_swapon: remove initial value of name variable
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
> Now there is nothing which jumps to the cleanup blocks before the name
> variable is set. There is no need to set it initially to NULL anymore.
>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> Tested-by: Eric B Munson <emunson@mgebm.net>
> Acked-by: Eric B Munson <emunson@mgebm.net>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
