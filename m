Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab0LGT4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 14:56:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab0LGT4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 14:56:20 -0500
Subject: Re: [PATCH 1/6] fsnotify: introduce new group mutex
From: Eric Paris <eparis@redhat.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20101202100148.GB5196@lsanfilippo.unix.rd.tt.avira.com>
References: <20101202100148.GB5196@lsanfilippo.unix.rd.tt.avira.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 14:56:16 -0500
Message-ID: <1291751776.3072.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 11:01 +0100, Lino Sanfilippo wrote:
> This patch intoduces a group specific mutex that is used to synchronize all 
> group related data/tasks for which no dedicated lock exists yet. 
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>

Patch 1-4 applied to for-next;

