Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab0FKPrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 11:47:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab0FKPrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 11:47:04 -0400
Message-ID: <4C125A6C.2090805@redhat.com>
Date: Fri, 11 Jun 2010 10:46:52 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Tao Ma <tao.ma@oracle.com>
CC: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: fiemap is broken for sparse file in ext4?
References: <4C119C2E.2090801@oracle.com> <4C11B6D8.8070909@redhat.com> <4C11C41C.9070000@oracle.com>
In-Reply-To: <4C11C41C.9070000@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tao Ma wrote:

>> What are you using to call fiemap?  Here it seems to be working:
> I just wrote a simple test program by calling ioctl. It is attached.
> btw, you need to call it immediately after dd so that we have a chance
> that ext4 don't have time to allocate extents. ;)

OK I take it back, I do see it.  *cough* too many different filesystems
on this box ... ;)

Yes, it does look like a bug.

-Eric

