Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab0DLDKF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 23:10:05 -0400
Received: from tundra.namei.org ([65.99.196.166]:53213 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab0DLDKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 23:10:01 -0400
Date: Mon, 12 Apr 2010 13:09:48 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2] security: remove dead hook acct
In-Reply-To: <20100409193324.23535.36578.stgit@paris.rdu.redhat.com>
Message-ID: <alpine.LRH.2.00.1004121309300.21578@tundra.namei.org>
References: <20100409193324.23535.36578.stgit@paris.rdu.redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Apr 2010, Eric Paris wrote:

> Unused hook.  Remove.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>


All applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
