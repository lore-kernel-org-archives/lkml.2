Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab1CZPB6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 11:01:58 -0400
Received: from kroah.org ([198.145.64.141]:60252 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab1CZPB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 11:01:56 -0400
Date: Sat, 26 Mar 2011 07:58:42 -0700
From: Greg KH <greg@kroah.com>
To: Liu Yuan <namei.unix@gmail.com>
Cc: linux-kernel@vger.kernel.org, nfont@austin.ibm.com
Subject: Re: [PATCH] drivers: Initialize ret to fix build warning in
 memory_probe_store
Message-ID: <20110326145842.GA23283@kroah.com>
References: <1300884347-3225-1-git-send-email-tailai.ly@taobao.com>
 <AANLkTimaF-MLHpG6JsmR+-EW-hDsVVWFZ2NWFrFHkE5d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimaF-MLHpG6JsmR+-EW-hDsVVWFZ2NWFrFHkE5d@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 26, 2011 at 03:49:30PM +0800, Liu Yuan wrote:
> Cc: Nathan Fontenot <nfont@austin.ibm.com>
> 
> On Wed, Mar 23, 2011 at 8:45 PM, Liu Yuan  <namei.unix@gmail.com> wrote:
> > From: Liu Yuan <tailai.ly@taobao.com>
> >
> > This fix a build warning in drivers/base/memory.c.
> >
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Signed-off-by: Liu Yuan <tailai.ly@taobao.com>

This is in my queue, please wait until .39-rc1 is out before I get to
this...

thanks,

greg k-h
