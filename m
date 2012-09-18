Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab2IRUTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:19:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39539 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab2IRUTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:19:37 -0400
Date: Tue, 18 Sep 2012 13:19:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: Taint kernel when we detect a corrupted slab.
In-Reply-To: <20120918195412.GB27689@redhat.com>
Message-ID: <alpine.DEB.2.00.1209181319191.25146@chino.kir.corp.google.com>
References: <20120918150543.GA14718@redhat.com> <00000139da509650-e5756e3f-f538-4735-afcd-c3c8ac9035b7-000000@email.amazonses.com> <alpine.DEB.2.00.1209181227190.25146@chino.kir.corp.google.com> <20120918195412.GB27689@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2012, Dave Jones wrote:

> It doesn't seem worth adding a new taint flag for this, so just re-use
> the one from 'bad page'
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Acked-by: David Rientjes <rientjes@google.com>
