Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab0F1UFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 16:05:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36742 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab0F1UFB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 16:05:01 -0400
Subject: Re: [PATCH] Add munmap events to perf
From: Peter Zijlstra <peterz@infradead.org>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: mingo@elte.hu, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Anton Blanchard <anton@samba.org>
In-Reply-To: <1277748484-23882-1-git-send-email-ebmunson@us.ibm.com>
References: <1277748484-23882-1-git-send-email-ebmunson@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Jun 2010 22:04:46 +0200
Message-ID: <1277755486.3561.140.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-28 at 19:08 +0100, Eric B Munson wrote:
> This patch adds a new software event for munmaps.  It will allows
> users to profile changes to address space.  munmaps will be tracked
> with mmaps.

Why?
