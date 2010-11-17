Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935130Ab0KQSQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 13:16:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933148Ab0KQSQX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 13:16:23 -0500
MIME-Version: 1.0
In-Reply-To: <20101117172111.GA26812@havoc.gtf.org>
References: <20101117172111.GA26812@havoc.gtf.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 17 Nov 2010 10:15:54 -0800
Message-ID: <AANLkTimwwCDfXSk5aEfHv3qzcvTzOQUB5fOCU4c5JJ8V@mail.gmail.com>
Subject: Re: [PATCH v2] libata: remove scsi host lock and serial number usage
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, James.Bottomley@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 9:21 AM, Jeff Garzik <jeff@garzik.org> wrote:
>
> Much better...  Just updated #upstream-fixes with the below patch.

Yes. This looks like a real improvement and actually gets rid of that
silly lock entirely. Good.

                       Linus
