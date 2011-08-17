Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab1HQHoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 03:44:07 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:59230 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab1HQHoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 03:44:05 -0400
Date: Wed, 17 Aug 2011 09:43:47 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [patch 1/1] [PATCH] include storage keys in hibernation image.
Message-ID: <20110817094347.3c106bd9@mschwide>
In-Reply-To: <201108161956.47434.rjw@sisk.pl>
References: <20110816141441.898339466@de.ibm.com>
	<20110816141541.237704940@de.ibm.com>
	<201108161956.47434.rjw@sisk.pl>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Aug 2011 19:56:47 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday, August 16, 2011, Martin Schwidefsky wrote:
> > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > 
> > For s390 there is one additional byte associated with each page,
> > the storage key. This byte contains the referenced and changed
> > bits and needs to be included into the hibernation image.
> > If the storage keys are not restored to their previous state all
> > original pages would appear to be dirty. This can cause
> > inconsistencies e.g. with read-only filesystems.
> > 
> > Cc: Pavel Machek <pavel@ucw.cz>
> > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > Cc: Jiri Slaby <jslaby@suse.cz>
> > Cc: linux-pm@lists.linux-foundation.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: linux-s390@vger.kernel.org
> > Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> OK, I don't have any complaints.  Do you want me to take this
> patch or do you want to push it through the s390 tree?

The patch affects the common power management code. At minimum I
would like an acked-by to take it into the s390 tree. I would feel
more comfortable if you'd take it via the power management tree
though.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

