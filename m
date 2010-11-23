Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab0KWTym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 14:54:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab0KWTyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 14:54:41 -0500
Subject: Re: [PATCH] fanotify: Dont allow a mask of 0 if setting or
 removing a mark
From: Eric Paris <eparis@redhat.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20101122174633.GB5512@lsanfilippo.unix.rd.tt.avira.com>
References: <20101122174633.GB5512@lsanfilippo.unix.rd.tt.avira.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 14:54:36 -0500
Message-ID: <1290542076.1443.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 18:46 +0100, Lino Sanfilippo wrote:
> In mark_remove_from_mask() we destroy marks that have their event mask cleared.
> Thus we should not allow the creation of those marks in the first place.
> With this patch we check if the mask given from user is 0 in case of FAN_MARK_ADD.
> If so we return an error. Same for FAN_MARK_REMOVE since this does not have any
> effect.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>

applied.  Thanks.

