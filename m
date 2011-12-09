Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab1LIBJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 20:09:14 -0500
Received: from tundra.namei.org ([65.99.196.166]:53553 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab1LIBJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 20:09:11 -0500
Date: Fri, 9 Dec 2011 12:09:08 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: John Johansen <john.johansen@canonical.com>
cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] apparmor: add missing rcu_dereference()
In-Reply-To: <4EE15B39.9050302@canonical.com>
Message-ID: <alpine.LRH.2.00.1112091208550.19846@tundra.namei.org>
References: <20111209002548.GA30520@www.outflux.net> <4EE15B39.9050302@canonical.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Dec 2011, John Johansen wrote:

> On 12/08/2011 04:25 PM, Kees Cook wrote:
> > Adds a missed rcu_dereference() around real_parent.

Applied to
git://selinuxproject.org/~jmorris/linux-security next

-- 
James Morris
<jmorris@namei.org>
