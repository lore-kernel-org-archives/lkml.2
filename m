Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab2HJU6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 16:58:41 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41455 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754950Ab2HJU6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 16:58:38 -0400
X-Sasl-enc: aGaYYl7IPrxU01aHNKFDkKdcO1C7wtVms67Q4aY97OJm 1344632317
Message-ID: <1344632282.9131.5.camel@lenny>
Subject: linux-user-chroot 2012.2
From: Colin Walters <walters@verbum.org>
To: linux-kernel@vger.kernel.org
Cc: luto@amacapital.net
Date: Fri, 10 Aug 2012 16:58:02 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the release of linux-user-chroot 2012.2.  The major change now
is that it makes use of Andy's new PR_SET_NO_NEW_PRIVS.  This doesn't
close any security hole I'm aware of - our previous use of the MS_NOSUID
bind mount over / should work - but, belt and suspenders as they say.

The code:
http://git.gnome.org/browse/linux-user-chroot/commit/?id=515c714471d0b5923f6633ef44a2270b23656ee9

As for how linux-user-chroot and PR_SET_NO_NEW_PRIVS relate, see this
thread:
http://thread.gmane.org/gmane.linux.kernel.lsm/15339

Summary
-------

This tool allows regular (non-root) users to call chroot(2), create
Linux bind mounts, and use some Linux container features.  It's
primarily intended for use by build systems.

Project information
-------------------

There's no web page yet; send patches to
Colin Walters <walters@verbum.org>



