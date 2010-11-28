Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab0K1WFe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 17:05:34 -0500
Received: from tundra.namei.org ([65.99.196.166]:58580 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab0K1WFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 17:05:33 -0500
Date: Mon, 29 Nov 2010 09:05:31 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Smack: UDS revision
In-Reply-To: <4CEDB7EA.1070106@schaufler-ca.com>
Message-ID: <alpine.LRH.2.00.1011290904540.15604@tundra.namei.org>
References: <4CEDB7EA.1070106@schaufler-ca.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010, Casey Schaufler wrote:

> 
> Subject: [PATCH] Smack: UDS revision
> 
>     This patch addresses a number of long standing issues
>     with the way Smack treats UNIX domain sockets.
>     
>     All access control was being done based on the label of
>     the file system object. This is inconsistant with the
>     internet domain, in which access is done based on the
>     IPIN and IPOUT attributes of the socket. As a result
>     of the inode label policy it was not possible to use
>     a UDS socket for label cognizant services, including
>     dbus and the X11 server.
>     
>     Support for SCM_PEERSEC on UDS sockets is also provided.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

(I'm guessing you wanted me to apply this).

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
