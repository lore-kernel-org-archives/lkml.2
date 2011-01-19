Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab1ASTTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 14:19:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab1ASTTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 14:19:02 -0500
Subject: Re: [RESEND][RFC][PATCH] fsnotify: track all events on filesystem
From: Eric Paris <eparis@redhat.com>
To: Jakob Goldbach <jakob.goldbach@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 19 Jan 2011 14:18:55 -0500
In-Reply-To: <20100713153626.EB8B140434E@localdomain.local>
References: <20100713153626.EB8B140434E@localdomain.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1295464736.21577.23.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-13 at 17:36 +0200, Jakob Goldbach wrote:
> (Resending, this time with fsnotify maintainer cc'ed)
> 
> This patch allows notification groups to get events on the entire filesystem,
> not just on registered inodes.
> 
> I want to use it for a notification group that tracks all changes to the 
> filesystem in order to do faster backups.
> 
> Is this a good or bad idea? 
> 
> /Jakob

This mail (like many notification e-mails) was eaten by my spam filter.
I hope you've gotten an answer by now, but I'll respond 6 months late.
We allow you to do something very similar, by listening to events on
mount points.  Hopefully that meets your needs.....

-Eric

