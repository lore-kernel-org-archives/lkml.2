Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab1CULhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 07:37:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21409 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab1CULhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 07:37:50 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC] a couple of i_nlink fixes in btrfs
In-reply-to: <20110321051725.GS22723@ZenIV.linux.org.uk>
References: <20110304171353.GU22723@ZenIV.linux.org.uk> <1299517070-sup-1687@think> <20110321051725.GS22723@ZenIV.linux.org.uk>
Date: Mon, 21 Mar 2011 07:37:02 -0400
Message-Id: <1300707383-sup-9821@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D87388B.017B,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Al Viro's message of 2011-03-21 01:17:25 -0400:
> On Mon, Mar 07, 2011 at 11:58:13AM -0500, Chris Mason wrote:
> 
> > Thanks, these both look good but I'll test here as well.  Are you
> > planning on pushing for .38?
> 
> No, but .39 would be nice ;-)  Do you want that to go through btrfs tree
> or through vfs one?

I'll take them in mine, it'll be easier to put in with all these other
changes.

-chris
