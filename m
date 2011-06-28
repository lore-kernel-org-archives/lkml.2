Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab1F1VRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 17:17:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab1F1VQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 17:16:59 -0400
Date: Tue, 28 Jun 2011 17:16:47 -0400
From: Dave Jones <davej@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: David Daney <ddaney.cavm@gmail.com>, Christoph Lameter <cl@linux.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] slub: reduce overhead of slub_debug
Message-ID: <20110628211647.GB11660@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Rientjes <rientjes@google.com>,
	David Daney <ddaney.cavm@gmail.com>,
	Christoph Lameter <cl@linux.com>,
	Marcin Slusarz <marcin.slusarz@gmail.com>,
	Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
References: <20110626193918.GA3339@joi.lan>
 <alpine.DEB.2.00.1106281431370.27518@router.home>
 <4E0A2E26.5000001@gmail.com>
 <alpine.DEB.2.00.1106281355010.4229@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1106281355010.4229@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 01:58:06PM -0700, David Rientjes wrote:

 > SLUB debugging is useful only to diagnose issues or test new code, nobody 
 > is going to be enabling it in production environment.  We don't need 30 
 > new lines of code that make one thing slightly faster

During five of the six months of development, Fedora kernels are built with
slub debugging forced on.  And it turns up problems every single release.

Having the impact of this be lower is very desirable. If this doesn't get
merged, I'd be tempted to carry it in Fedora regardless for this reason.

	Dave

