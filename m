Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab0EaI4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 04:56:31 -0400
Received: from mtagate4.de.ibm.com ([195.212.17.164]:41185 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738Ab0EaI43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 04:56:29 -0400
Date: Mon, 31 May 2010 10:56:26 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Julia Lawall <julia@diku.dk>, Carsten Otte <cotte@de.ibm.com>,
       linux390@de.ibm.com, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/3] arch/s390/kvm: Use GFP_ATOMIC when a lock is held
Message-ID: <20100531105626.35395a03@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <201005311038.07755.borntraeger@de.ibm.com>
References: <Pine.LNX.4.64.1005302227470.19253@ask.diku.dk>
	<201005311038.07755.borntraeger@de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 May 2010 10:38:07 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> > The containing function is called from several places.  At one of them, in
> > the function __sigp_stop, the spin lock &fi->lock is held.
> [...]
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

Ok, I'll add the patch to git390. Thanks.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

