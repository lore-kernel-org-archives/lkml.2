Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2ARVgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 16:36:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53880 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab2ARVgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 16:36:42 -0500
Date: Wed, 18 Jan 2012 13:36:38 -0800
From: Tejun Heo <tj@kernel.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Lennart Poettering <mzxreary@0pointer.de>
Subject: Re: [PATCH 2/2] cgroup: add xattr support
Message-ID: <20120118213638.GA21533@google.com>
References: <4F13DA90.2000603@cn.fujitsu.com>
 <4F13DAA9.4070703@cn.fujitsu.com>
 <20120117175322.GC6762@google.com>
 <CAPXgP13fT3V4L0x6uj9ZdAOw25BgQtEpa8QzLB-_c_Yn+9kO2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP13fT3V4L0x6uj9ZdAOw25BgQtEpa8QzLB-_c_Yn+9kO2Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 18, 2012 at 10:28:42PM +0100, Kay Sievers wrote:
> The idea with the cgroup fs xattrs was to be able to attach some
> general useful attributes to the 'service container' itself, instead
> of keeping them in the memory of the managing process or store them on
> disk which can get out-of-sync much easier.

Hmmm.... I can see the attraction but there really is nothing which
binds that information to cgroup.  The same information might as well
live in /proc/PID/userland_data or whatever.  It may be convenient now
but I'm pretty skeptical it's a good idea in the long run.

Given that cgroups themselves need to be explicitly created and
destroyed, maintaining a parallel tmpfs hierarchy for metadata, if
necessary, shouldn't be too bothersome, right?

Thanks.

-- 
tejun
