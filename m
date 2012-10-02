Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab2JBPuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:50:32 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59992
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753838Ab2JBPua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:50:30 -0400
Date: Tue, 2 Oct 2012 11:50:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: viro@ZenIV.linux.org.uk, eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: Re: [PATCH v7 05/49] audit: add a new "type" field to audit_names
 struct
Message-ID: <20121002155028.GA22698@infradead.org>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
 <1349137018-21948-6-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349137018-21948-6-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#define	AUDIT_TYPE_UNKNOWN	0	/* we don't know yet */
> +#define AUDIT_TYPE_NORMAL	1	/* a "normal" audit record */

I don't care about tab vs space after the #define, but at least be
consistent.

