Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab1IZSf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 14:35:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab1IZSf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 14:35:57 -0400
Subject: RE: [PATCH] gfs2/inode.c: local functions should be static
From: Steven Whitehouse <swhiteho@redhat.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F39DBB86BD@AUSP01VMBX24.collaborationhost.net>
References: <201109231551.32939.hartleys@visionengravers.com>
	 <1317025658.2744.0.camel@menhir>
	 <ADE657CA350FB648AAC2C43247A983F001F39DBB86BD@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 26 Sep 2011 19:37:28 +0100
Message-ID: <1317062248.2744.28.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2011-09-26 at 11:54 -0500, H Hartley Sweeten wrote:
> On Monday, September 26, 2011 1:28 AM, Steven Whitehouse wrote:
> > Hi,
> >
> > On Fri, 2011-09-23 at 15:51 -0700, H Hartley Sweeten wrote:
> >> Quiets the sparse noise:
> >> 
> >> warning: symbol 'gfs2_initxattrs' was not declared. Should it be static?
> >> 
> > Where did you find this function? It is not in the upstream gfs2 code...
> 
> linux-next next-20110831
> 
> This was the last update I pulled before git.kernel.org went down.
> 
> It looks like it was added by:
> 
> commit 9d8f13ba3f4833219e50767b022b82cd0da930eb
> Author: Mimi Zohar <zohar@linux.vnet.ibm.com>
> Date:   Mon Jun 6 15:29:25 2011 -0400
> 
>     security: new security_inode_init_security API adds function callback
> 
> If this has been removed since then please ignore.
> 
> Thanks,
> Hartley

I think it is a question of it not yet being added. You should send the
patch to Mimi so it is included in the correct patch series. Otherwise
remind me when the code is applies against is merged and I'll look at it
again then,

Steve.


