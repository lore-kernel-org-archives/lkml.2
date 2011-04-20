Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab1DTFxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 01:53:44 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55364 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1DTFxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 01:53:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=nsZKzQjhJS0sueO4lPn/gzA/T0wpKHQXLxSnQ+47/Jm6fCP4Gxz6F048V+k2IEJCs8
         kF8ITpzKlMGHVKz6XzBUMkXKlh3Wo2MrrN7ppTrb4lCeQIjo9S5R/789z2jZ6pGrvoAr
         /l5IL/IP6CcUl01F+TqPqn4cf9MKWXgbhdLgo=
MIME-Version: 1.0
In-Reply-To: <20110420102314.4604.A69D9226@jp.fujitsu.com>
References: <1303249716.11237.26.camel@mulgrave.site>
	<alpine.DEB.2.00.1104191657030.26867@router.home>
	<20110420102314.4604.A69D9226@jp.fujitsu.com>
Date: Wed, 20 Apr 2011 08:53:41 +0300
X-Google-Sender-Auth: r6gludV8YliwHNBAnYFM_lfQUNM
Message-ID: <BANLkTi=mxWwLPEnB+rGg29b06xNUD0XvsA@mail.gmail.com>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to expand_upwards
From: Pekka Enberg <penberg@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 4:23 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> I'm worry about this patch. A lot of mm code assume !NUMA systems
> only have node 0. Not only SLUB.

So is that a valid assumption or not? Christoph seems to think it is
and James seems to think it's not. Which way should we aim to fix it?
Would be nice if other people chimed in as we already know what James
and Christoph think.

                        Pekka
