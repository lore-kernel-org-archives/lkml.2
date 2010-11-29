Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab0K2UkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 15:40:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab0K2UkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 15:40:18 -0500
Subject: Re: [PATCH 1/2] fanotify: Introduce FAN_NOFD
From: Eric Paris <eparis@redhat.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20101124172209.GB18135@lsanfilippo.unix.rd.tt.avira.com>
References: <20101124172209.GB18135@lsanfilippo.unix.rd.tt.avira.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 15:40:13 -0500
Message-ID: <1291063213.3248.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 18:22 +0100, Lino Sanfilippo wrote:
> FAN_NOFD is used in fanotify events that do not provide an open file
> descriptor (like the overflow_event).
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>

applied to for-next

