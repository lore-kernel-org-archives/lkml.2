Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab0DUWHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 18:07:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65117 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab0DUWHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 18:07:03 -0400
Date: Wed, 21 Apr 2010 15:06:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 00/35] Union mounts - everything but the xattrs
Message-Id: <20100421150634.1f01240a.randy.dunlap@oracle.com>
In-Reply-To: <1271372682-21225-1-git-send-email-vaurora@redhat.com>
References: <1271372682-21225-1-git-send-email-vaurora@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090209.4BCF76F8.005C:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Apr 2010 16:04:07 -0700 Valerie Aurora wrote:

> This patch series implements union mounts for every system call
> except:
> 
> - xattr-related calls
> - fchmod()/fchown()/futimensat() on an fd
> 
> The copyup portion is a proof of concept based around union_path_nd(),
> which looks up both the target <mnt,dentry> pair and its parent's.  If
> the parent is on a union mount, and the target is on a lower layer, we
> copy up the target.
> 
> This patch set is very raw and could use even the most superficial
> review.  Just take a look at Erez's review from December to see how
> low-hanging the fruit is on this one.
> 
> -VAL


Hi VAL,

In the future, please make patches 1-N reply/refer to patch 0 instead of to
the preceding numbered patch.


thanks,
---
~Randy
