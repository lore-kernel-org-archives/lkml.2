Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab2BMQLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 11:11:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38501 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045Ab2BMQLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 11:11:49 -0500
Date: Mon, 13 Feb 2012 10:11:35 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "criu@openvz.org" <criu@openvz.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>
Subject: Re: [PATCH 0/5] IPC: checkpoint/restore in userspace enhancements
Message-ID: <20120213161135.GE5009@sergelap>
References: <20120209175043.24392.62810.stgit@localhost6.localdomain6>
 <4F356206.1080509@schaufler-ca.com>
 <4F38EE17.7090809@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F38EE17.7090809@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stanislav Kinsbursky (skinsbursky@parallels.com):
> 10.02.2012 22:29, Casey Schaufler пишет:
> >On 2/9/2012 10:01 AM, Stanislav Kinsbursky wrote:
> >>This patch set aimed to provide additional functionality for all IPC objects,
> >>which is required for migration these objects by user-space checkpoint/restore
> >>utils.
> >>The main problem here was impossibility to set up object id. This patch set
> >>solves the problem in two steps:
> >>1) Makes it possible to create new object (shared memory, semaphores set or
> >>messages queue) with ID, equal to passed key.
> >>2) Makes it possible to change existent object key.
> >
> >Is there any chance you might include the LSM data as well?
> >
> 
> Sorry, but I don't understand your question.
> What is this "LSM"? Linux Shared Memory? If yes, and you mean SYSV
> IPC SHM, then where do you want to include it?

He means linux security modules.  (see include/linux/security.h)
