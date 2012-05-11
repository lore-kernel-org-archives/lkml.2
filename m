Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718Ab2EKQYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 12:24:15 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21523 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab2EKQYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 12:24:13 -0400
MIME-Version: 1.0
Message-ID: <1ff67ec4-7dd0-49c8-9be2-e927f58e6472@default>
Date: Fri, 11 May 2012 09:23:12 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Julian Andres Klode <jak@jak-linux.org>, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, sjenning@linux.vnet.ibm.com
Subject: RE: [PATCH] ramster: switch over to zsmalloc and crypto interface
References: <1336676781-8571-1-git-send-email-dan.magenheimer@oracle.com>
 <20120510192836.GA17750@jak-linux.org>
In-Reply-To: <20120510192836.GA17750@jak-linux.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Julian Andres Klode [mailto:jak@jak-linux.org]
> Sent: Thursday, May 10, 2012 1:29 PM
> To: Dan Magenheimer
> Cc: devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org; linux-
> mm@kvack.org; ngupta@vflare.org; Konrad Wilk; sjenning@linux.vnet.ibm.com
> Subject: Re: [PATCH] ramster: switch over to zsmalloc and crypto interface
> 
> On Thu, May 10, 2012 at 12:06:21PM -0700, Dan Magenheimer wrote:
> > RAMster does many zcache-like things.  In order to avoid major
> > merge conflicts at 3.4, ramster used lzo1x directly for compression
> > and retained a local copy of xvmalloc, while zcache moved to the
> > new zsmalloc allocator and the crypto API.
> >
> > This patch moves ramster forward to use zsmalloc and crypto.
> >
> > Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com
> 
> Nothing important, but the right ">" is missing here.

Oops!  Cut-and-paste error!  Thanks for noticing Julian!

Greg, do you need me to resubmit with the missing '>'?

Thanks,
Dan
