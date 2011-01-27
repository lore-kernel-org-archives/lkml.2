Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab1A0SkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 13:40:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39455 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab1A0SkC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 13:40:02 -0500
MIME-Version: 1.0
In-Reply-To: <ih8he2$41t$2@dough.gmane.org>
References: <20110119222630.6755.63928.stgit@paris.rdu.redhat.com>
	<ih8gpe$41t$1@dough.gmane.org>
	<ih8he2$41t$2@dough.gmane.org>
Date: Thu, 27 Jan 2011 13:40:02 -0500
Message-ID: <AANLkTi=LJWvT5r=0rSBxV4aQdm6n2YAS_0y0RkKdTXQp@mail.gmail.com>
Subject: Re: [PATCH] kexec: include sysctl to disable
From: Eric Paris <eparis@parisplace.org>
To: WANG Cong <xiyou.wangcong@gmail.com>, Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping, not hearing any argument is usually a good thing   :)

-Eric

On Thu, Jan 20, 2011 at 12:32 AM, WANG Cong <xiyou.wangcong@gmail.com> wrote:

>> On Wed, 19 Jan 2011 17:26:30 -0500, Eric Paris wrote:
>>
>>> much like /proc/sys/kernel/modules_disable is used to disable module
>>> loading, /proc/sys/kernel/kexec_disable is used to disable kexec code
>>> loading.  It would still be possible to use kexec -l to load a kernel,
>>> set the tunable to 1 so the kernel waiting to boot couldn't change, and
>>> then launch the kernel at a later time (through kexec -e or through a
>>> crash)

> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
