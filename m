Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab0K2Ukj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 15:40:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690Ab0K2Uki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 15:40:38 -0500
Subject: Re: [PATCH 2/2] fanotify: Dont try to open a file descriptor for
 the overflow event
From: Eric Paris <eparis@redhat.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20101124172604.GC18135@lsanfilippo.unix.rd.tt.avira.com>
References: <20101124172604.GC18135@lsanfilippo.unix.rd.tt.avira.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 15:40:28 -0500
Message-ID: <1291063228.3248.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 18:26 +0100, Lino Sanfilippo wrote:
> We should not try to open a file descriptor for the overflow event since this
> will always fail.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>

applied to for-next

