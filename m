Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab1AHI3t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 03:29:49 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:47432 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab1AHI3s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 03:29:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=N2p0D2MQHKOEJiYOFBxRw4WevPb006CaOXB80czuuk1Zh5PYKBE3kGevZdVvUjfjCF
         /ajuL20XSmoFFPMJK0jXmYzEN4ltYcLaVTiVmH6+s/K2Fh3TK61H7/5OTHthtbpEIXoG
         IaFmHn+ZnbTOvDTpEll9538pdq+x9765ww3Do=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1101071227160.31653@chino.kir.corp.google.com>
References: <1294172717-6044-1-git-send-email-penberg@kernel.org>
	<alpine.DEB.2.00.1101041939030.27551@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1101050943120.13032@router.home>
	<alpine.DEB.2.00.1101051108520.14761@router.home>
	<AANLkTinft80dXqE-U=YDB23d9=BgXLCxJzgiA_gF4cVL@mail.gmail.com>
	<AANLkTinCZzJWYGnxXq_Nwv7QSkEV4Tg-te-1y0PCeRRY@mail.gmail.com>
	<AANLkTinQMahgVrWLxR0J6Zbh-_SPjxVJ-wuZt8B5TNjc@mail.gmail.com>
	<alpine.DEB.2.00.1101060019140.25879@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1101061107500.8655@router.home>
	<20110107091106.aaa07abe.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1101070922100.3014@router.home>
	<alpine.DEB.2.00.1101071227160.31653@chino.kir.corp.google.com>
Date: Sat, 8 Jan 2011 10:29:47 +0200
X-Google-Sender-Auth: gm3HY0JqJ-fnsIsd_EEdamAkXG8
Message-ID: <AANLkTikf-qO-NkysOsgRvH08ju-NkvrqwdfJ=pFjP6WA@mail.gmail.com>
Subject: Re: [PATCH] slub: Fix sysfs circular locking dependency
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 10:34 PM, David Rientjes <rientjes@google.com> wrote:
>  [ Should probably be seperated out into two patches, one for the
>   memory hotplug locking addition and one for the slub fix, both
>   should be pushed during this merge window.  If so, a comment
>   describing the new semantics of lock_memory_hotplug() to protect
>   data structures that may be modified in hotplug notifier
>   callbacks would be appreciated. ]

Agreed.
