Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab2JRNlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:41:01 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36450 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab2JRNk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:40:59 -0400
Date: Thu, 18 Oct 2012 16:40:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sangho Yi <antiroot@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] staging: csr: fixed indentation from spaces to
 tabs on io.c
Message-ID: <20121018134045.GQ5685@mwanda>
References: <n>
 <1350321868-2613-1-git-send-email-antiroot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350321868-2613-1-git-send-email-antiroot@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 02:24:20AM +0900, Sangho Yi wrote:
>  static int uf_read_proc(char *page, char **start, off_t offset, int count,
> -                        int *eof, void *data);
> +						int *eof, void *data);

The original was correct.  The new one is wrong.

I'm not reviewing any more of this patchset.  Sorry.  Please redo
everything.

regards,
dan carpenter

