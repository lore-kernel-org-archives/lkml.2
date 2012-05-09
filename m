Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682Ab2EIV77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 17:59:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab2EIV76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 17:59:58 -0400
Date: Wed, 9 May 2012 14:59:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: axboe@kernel.dk, stephenmcameron@gmail.com, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, thenzl@redhat.com
Subject: Re: [PATCH] cciss: fix incorrect scsi status reporting
Message-Id: <20120509145956.97b4ff63.akpm@linux-foundation.org>
In-Reply-To: <20120504182114.24883.40748.stgit@beardog.cce.hp.com>
References: <20120504182114.24883.40748.stgit@beardog.cce.hp.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 May 2012 13:21:14 -0500
"Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:

> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> Delete code which sets SCSI status incorrectly as it's already
> been set correctly above this incorrect code.  Bug was introduced
> by b0e15f6db1110319cb2e747e59e1200450a5ba3e
> "cciss: fix typo that causes scsi status to be lost." in 2009.
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> Reported-and-tested-by: Roel van Meer <roel.vanmeer@bokxing.nl>
> Cc: stable@vger.kernel.org

If the bug is three years old, it presumably isn't a terribly serious
one.  Why was the -stable backport recommended?

