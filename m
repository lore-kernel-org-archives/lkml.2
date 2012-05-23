Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445Ab2EWOs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:48:57 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:21603 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755518Ab2EWOsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:48:54 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zJySe6AVM1lgLHGnTDzfa6hojGFqRrSJQW3hUh7ayUv_E0p
 TEDTFgu5Qa4oNv9saQe08qAOlRYRtySMCyYiPlR3uGZ.w6Qvrb9.GvDBPHBe
 eFeyLimRRTZH6lXdJDLmhSJxFYrE6LlKzVGM3wbJkcHJSrzho7w3Inrdr.3T
 6E1cTa6fYvSWEOGFT4yad1Pua4JJpvw6gDlaxa_GSqcLGJbmBhZ7v2E_thFj
 OaHDAdQX20y.Oso5lrK5kOFrhfp7mMXuNjXSJWYvOeJmAWIBefRpkrO3_Coh
 0FKcXrD2c_mDqIkmQpMwerKT3qCik_0XKOa52h50eHT0UqIO_vGvgdWB4.dz
 2qeR1Lq5eCBJ_BcAuTJLkrP8sO8SYMirqG6NqQ2ZmjPl28KVMLObosQe2Lot
 b
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 23 May 2012 09:48:51 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Glauber Costa <glommer@parallels.com>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab+slob: dup name string
In-Reply-To: <1337775878.3013.16.camel@dabdike.int.hansenpartnership.com>
Message-ID: <alpine.DEB.2.00.1205230947490.30940@router.home>
References: <1337613539-29108-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com> <alpine.DEB.2.00.1205220855470.17600@router.home> <4FBBAE95.6080608@parallels.com> <alpine.DEB.2.00.1205221216050.17721@router.home>
 <alpine.DEB.2.00.1205221529340.18325@chino.kir.corp.google.com> <1337773595.3013.15.camel@dabdike.int.hansenpartnership.com> <4FBCD328.6060406@parallels.com> <1337775878.3013.16.camel@dabdike.int.hansenpartnership.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, James Bottomley wrote:

> > > So, why not simply patch slab to rely on the string lifetime being the
> > > cache lifetime (or beyond) and therefore not having it take a copy?

Well thats they way it was for a long time. There must be some reason that
someone started to add this copying business....  Pekka?

