Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760906Ab2J2Uvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:51:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab2J2Uvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:51:32 -0400
Date: Mon, 29 Oct 2012 13:51:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        skinsbursky@parallels.com
Subject: Re: ipc, msgqueue: NULL ptr deref in msgrcv
Message-Id: <20121029135130.a83ca655.akpm@linux-foundation.org>
In-Reply-To: <508C80D9.7080803@oracle.com>
References: <5089DCA2.2040200@oracle.com>
	<508C80D9.7080803@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2012 20:48:25 -0400
Sasha Levin <sasha.levin@oracle.com> wrote:

> My auto-bisect script just finished running. Looks like it's caused by:
> 
> e32811fe04c759faf63c93b470e787b2328ceb04 is the first bad commit
> commit e32811fe04c759faf63c93b470e787b2328ceb04
> Author: Stanislav Kinsbursky <skinsbursky@parallels.com>
> Date:   Thu Oct 25 12:15:18 2012 +1100
> 
>     ipc: message queue copy feature introduced

Thanks.  I have made a note this and shall go into wait-and-see mode on
that patch series.

