Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909Ab1IIHa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 03:30:58 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:45366 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492Ab1IIHa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 03:30:56 -0400
Date: Fri, 9 Sep 2011 00:30:25 -0700
From: Dan Carpenter <error27@gmail.com>
To: Chris Boot <bootc@bootc.net>
Cc: Arvydas Sidorenko <asido4@gmail.com>, devel@driverdev.osuosl.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] typedef cleanup
Message-ID: <20110909073025.GE17041@mwanda>
References: <1315166085-27984-1-git-send-email-asido4@gmail.com>
 <1315166085-27984-3-git-send-email-asido4@gmail.com>
 <A80909DB-416A-4E81-AEB9-1308366FC693@bootc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A80909DB-416A-4E81-AEB9-1308366FC693@bootc.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 07:35:37PM +0200, Chris Boot wrote:
> On 4 Sep 2011, at 21:54, Arvydas Sidorenko wrote:
> 
> > #ifndef uint64_t
> > -typedef struct _uint64_t {
> > +struct _uint64_t {
> > 	uint32_t low_dw;
> > 	uint32_t hi_dw;
> > } uint64_t;
> > #endif
> 
> This can't be right can it? You're changing a typedef into a
> variable definition as far as I can see.

Yes.  You are right.  The "uint64_t" is a variable now so this patch
is wrong.

(Or maybe you knew that and the question was rhetorical?  It's hard
to tell over email.)

regards,
dan carpenter

