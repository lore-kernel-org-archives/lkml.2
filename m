Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab1ASRNC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 12:13:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab1ASRNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:13:00 -0500
Subject: Re: [PATCH 0/14] fsnotify: simplify locking
From: Eric Paris <eparis@redhat.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Date: Wed, 19 Jan 2011 12:12:51 -0500
In-Reply-To: <1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1295457172.21577.19.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 17:42 +0100, Lino Sanfilippo wrote:

> The main goal of these patches is to change the locking order to 
> 
> group->mark_lock
> inode->i_lock
> mark->lock

There was a LOT of thought that went into the object locking and
lifetime to make sure it was safe, but I agree it is, ummm, complex.
I'll look at these patches but offhand I seem to recall that (by
definition) inode->i_lock was always supposed to be the smallest lock
ever held.  I added Al a VFS guy, who might veto these patches just on
that alone......

-Eric

