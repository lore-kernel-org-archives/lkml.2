Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab2JVVEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:04:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab2JVVEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:04:50 -0400
Date: Mon, 22 Oct 2012 14:04:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sangho Yi <antiroot@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 01/14] staging: csr: fixed indentation from spaces to
 tabs on io.c
Message-ID: <20121022210446.GB23826@kroah.com>
References: <n>
 <1350321868-2613-1-git-send-email-antiroot@gmail.com>
 <20121018134045.GQ5685@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018134045.GQ5685@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 04:40:46PM +0300, Dan Carpenter wrote:
> On Tue, Oct 16, 2012 at 02:24:20AM +0900, Sangho Yi wrote:
> >  static int uf_read_proc(char *page, char **start, off_t offset, int count,
> > -                        int *eof, void *data);
> > +						int *eof, void *data);
> 
> The original was correct.  The new one is wrong.
> 
> I'm not reviewing any more of this patchset.  Sorry.  Please redo
> everything.

I agree, this series can't be accepted, sorry.

greg k-h
