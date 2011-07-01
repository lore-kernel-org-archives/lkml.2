Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab1GAIQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 04:16:06 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52305
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755139Ab1GAIQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 04:16:04 -0400
Date: Fri, 1 Jul 2011 04:16:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 34/40] Staging: hv: storvsc: Add the contents of
 hyperv_storage.h to storvsc_drv.c
Message-ID: <20110701081601.GB28322@infradead.org>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-34-git-send-email-kys@microsoft.com>
 <20110630194530.GE22707@infradead.org>
 <6E21E5352C11B742B20C142EB499E0480816C297@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0480816C297@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 08:13:51PM +0000, KY Srinivasan wrote:
> > > Add the contents of hyperv_storage.h to storvsc_drv.c and cleanup
> > storvsc_drv.c.n
> > 
> > I'd at least leave the first half of the header that defines the
> > protocol around.
> 
> I only got rid of the block comment at the start of hyperv_storage.h
> and consolidated the include files. Nothing of substance was deleted.

I meant to say keeping a separate header file for the protocol defintion
might be a good idea.  That way it is kept separate from the
implementation details

