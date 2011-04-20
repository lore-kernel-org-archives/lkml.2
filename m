Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab1DTSKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 14:10:00 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45840 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751465Ab1DTSJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 14:09:59 -0400
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Lameter <cl@linux.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        x86 maintainers <x86@kernel.org>
In-Reply-To: <alpine.DEB.2.00.1104201149520.12154@router.home>
References: <20110420161615.462D.A69D9226@jp.fujitsu.com>
	 <BANLkTimfpY3gq8oY6bPDajBW7JN6Hp+A0A@mail.gmail.com>
	 <20110420174027.4631.A69D9226@jp.fujitsu.com>
	 <1303317178.2587.30.camel@mulgrave.site>
	 <alpine.DEB.2.00.1104201149520.12154@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 13:09:55 -0500
Message-ID: <1303322995.2587.42.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-20 at 11:50 -0500, Christoph Lameter wrote:
> > I'm afraid it doesn't boot (it's another slub crash):
> 
> Is there any simulator available that we can use to run a parisc boot?

I don't think we have a simulator.  However, if you send a ssh key to

T-Bone@parisc-linux.org

He can loan you remote access to one of the systems that ESIEE in France
hosts for us.  (he's expecting you).

James


