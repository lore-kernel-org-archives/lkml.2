Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab2JBQ4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:56:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab2JBQ4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:56:06 -0400
Date: Tue, 2 Oct 2012 12:55:56 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@ZenIV.linux.org.uk, eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: Re: [PATCH v7 05/49] audit: add a new "type" field to audit_names
 struct
Message-ID: <20121002125556.092f7796@tlielax.poochiereds.net>
In-Reply-To: <20121002155028.GA22698@infradead.org>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
	<1349137018-21948-6-git-send-email-jlayton@redhat.com>
	<20121002155028.GA22698@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2012 11:50:28 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> > +#define	AUDIT_TYPE_UNKNOWN	0	/* we don't know yet */
> > +#define AUDIT_TYPE_NORMAL	1	/* a "normal" audit record */
> 
> I don't care about tab vs space after the #define, but at least be
> consistent.
> 

I went ahead and fixed this in my tree but since it's just a whitespace
change, I'm not going to bother reposting unless Al requests it or
there are larger changes that need to be made.

-- 
Jeff Layton <jlayton@redhat.com>
