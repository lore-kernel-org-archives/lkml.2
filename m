Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1ASUqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 15:46:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab1ASUqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 15:46:22 -0500
Subject: Re: [PATCH] fs/notify/notification.c: make subsys_initcall static
From: Eric Paris <eparis@redhat.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, agruen@suse.de
Date: Wed, 19 Jan 2011 15:46:11 -0500
In-Reply-To: <201101181417.08751.hartleys@visionengravers.com>
References: <201101181417.08751.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1295469972.21577.36.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-18 at 14:17 -0700, H Hartley Sweeten wrote:
> The symbol fsnotify_notification_init is a subsys_initcall and can be declared
> static.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Eric Paris <eparis@redhat.com>
> Cc: Andreas Gruenbacher <agruen@suse.de>

Applied.  Thanks and sorry to be so slow.

-Eric

