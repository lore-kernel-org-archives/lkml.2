Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab3AIRdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 12:33:12 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:40475 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab3AIRdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 12:33:10 -0500
Date: Wed, 9 Jan 2013 21:33:04 +0400
From: Vasily Kulikov <segoon@openwall.com>
To: Eric Paris <eparis@parisplace.org>
Cc: LSM List <linux-security-module@vger.kernel.org>,
        linux-kernel@vger.kernel.org, libc-alpha@sourceware.org
Subject: Re: Friendlier EPERM e-mail on lkml
Message-ID: <20130109173304.GA16391@cachalot>
References: <CACLa4pvNYRLGG2t9Y40BYbqnxu9oTYjMWs71C9soJEiwzBMK5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACLa4pvNYRLGG2t9Y40BYbqnxu9oTYjMWs71C9soJEiwzBMK5Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Wed, Jan 09, 2013 at 11:18 -0500, Eric Paris wrote:
> http://marc.info/?l=linux-kernel&m=135774748910987&w=2
> 
> Basic idea is a proc file which tells you WHY the last EPERM from the
> kernel happened.  Was it SELinux?  Was it SMACK?  Was it capabilities?
>  Was it file rwx bits?
> 
> I'd like comments.  I'll cc LSM on any future replies to that thread...

Why does application need it?  Why does anybody but admin need this
information?

Probably this may be implemented as root-only audit messages?  Or
introduce new NETLINK_EPERMREASON netlink family?

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments
