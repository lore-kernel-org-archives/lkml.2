Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab1JRS6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 14:58:06 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34669
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752649Ab1JRS6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 14:58:05 -0400
Date: Tue, 18 Oct 2011 14:58:03 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Smith <dsmith@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] Tracepoint: add exec tracepoint
Message-ID: <20111018185803.GA32498@infradead.org>
References: <4E9DC85F.3080507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9DC85F.3080507@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 01:41:35PM -0500, David Smith wrote:
> Added general purpose exec tracepoint.  The 'bprm' argument gives details of the exec.

Given that you only need the filename from the bprm please just pass
it directly.

