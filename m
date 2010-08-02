Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab0HBGck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 02:32:40 -0400
Received: from smtp.outflux.net ([198.145.64.163]:33073 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab0HBGcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 02:32:39 -0400
Date: Sun, 1 Aug 2010 23:32:24 -0700
From: Kees Cook <kees.cook@canonical.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@ftp.linux.org.uk>, Tim Gardner <timg@canonical.com>
Subject: Re: Preview of changes to the Security susbystem for 2.6.36
Message-ID: <20100802063224.GR3948@outflux.net>
References: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org>
 <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 12:18:46PM +1000, James Morris wrote:
> On Fri, 30 Jul 2010, James Morris wrote:
> > One issue which needs to be addressed is to confirm that there is 
> > consensus on the new Yama LSM module.  I had thought there was, based on 
> > list discussion, but have since had differing feedback.
> 
> I'm going to revert the Yama stuff for 2.6.36 -- Christoph has nacked it 
> to me off-list.

Well, at least I'll have something for my summit presentation again.

On the other hand, it's rather hard for me to defend against a private NAK.
Care to describe the reasoning in public, Christoph?

James, will it stay in security-testing for .37 hopefully?

-Kees

-- 
Kees Cook
Ubuntu Security Team
