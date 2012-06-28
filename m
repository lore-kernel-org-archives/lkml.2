Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab2F1OzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 10:55:04 -0400
Received: from tundra.namei.org ([65.99.196.166]:33741 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab2F1OzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 10:55:01 -0400
Date: Fri, 29 Jun 2012 00:54:55 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Chad Williamson <chad@dahc.us>
cc: wad@chromium.org, james.l.morris@oracle.com, keescook@chromium.org,
        eparis@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] samples: seccomp: add .gitignore for untracked
 executables
In-Reply-To: <1340789620-15762-1-git-send-email-chad@dahc.us>
Message-ID: <alpine.LRH.2.02.1206290054440.30878@tundra.namei.org>
References: <1340789620-15762-1-git-send-email-chad@dahc.us>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012, Chad Williamson wrote:

> git status should be clean following make allmodconfig && make. Add
> a .gitignore file to the samples/seccomp directory to ignore binaries
> produced there.
> 
> Signed-off-by: Chad Williamson <chad@dahc.us>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next


