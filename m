Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab2F0OYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:24:40 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:39027 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab2F0OYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:24:38 -0400
Date: Wed, 27 Jun 2012 16:24:30 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, mst@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH v2 1/6] kvm: Pass kvm_irqfd to functions
Message-ID: <20120627162430.3477d0f6@BR9GNB5Z>
In-Reply-To: <20120627050858.23698.44118.stgit@bling.home>
References: <20120627044758.23698.249.stgit@bling.home>
	<20120627050858.23698.44118.stgit@bling.home>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12062714-4966-0000-0000-000002C35187
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2012 23:09:04 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> Prune this down to just the struct kvm_irqfd so we can avoid
> changing function definition for every flag or field we use.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

I'm currently trying to find a way to make irqfd workable for s390
which will likely include using a new field in kvm_irqfd, so I'd like
to have this change (and I also think it makes the code nicer to read).
So:

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>

