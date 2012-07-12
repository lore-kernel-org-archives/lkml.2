Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161556Ab2GLRuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:50:25 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54707 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932690Ab2GLRuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:50:20 -0400
Message-ID: <1342115416.3021.60.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 1/5] aio: Export symbols and struct kiocb_batch for in
 kernel aio usage
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Asias He <asias@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Date: Thu, 12 Jul 2012 18:50:16 +0100
In-Reply-To: <1342107302-28116-2-git-send-email-asias@redhat.com>
References: <1342107302-28116-1-git-send-email-asias@redhat.com>
	 <1342107302-28116-2-git-send-email-asias@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 23:35 +0800, Asias He wrote:
> This is useful for people who want to use aio in kernel, e.g. vhost-blk.
> 
> Signed-off-by: Asias He <asias@redhat.com>
> ---
>  fs/aio.c            |   37 ++++++++++++++++++-------------------
>  include/linux/aio.h |   21 +++++++++++++++++++++
>  2 files changed, 39 insertions(+), 19 deletions(-)

Um, I think you don't quite understand how aio in the kernel would work;
it's not as simple as just exporting the interfaces.  There's already a
(very long) patch set from oracle to do this so loop can use aio:

http://marc.info/?l=linux-fsdevel&m=133312234313122

James


