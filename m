Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab1EKVer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:34:47 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:45659 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753719Ab1EKVeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:34:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=OcR+gsvCfoCzLFU3pzmqzdPQcl6mKUyTPIAIUL7tg7XtBJW5KDaz4OEi4ILgGJrARDeOzyMY6Yn4jG4bGEIKdnrNU5/jl5LVP46TosJwHoZBEfcDMun0wxVmVqoX05C2;
Date: Wed, 11 May 2011 14:34:42 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/c6x: new architecture port for linux
Message-Id: <20110511143442.7c163a74.rdunlap@xenotime.net>
In-Reply-To: <1305144843-5058-1-git-send-email-msalter@redhat.com>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011 16:13:47 -0400 Mark Salter wrote:

> The project wiki for linux-c6x is at:
> 
>   http://www.linux-c6x.org
> 
> and the GIT tree holding the attached patches is at:
> 
>   git@linux-c6x.org:/git/projects/linux-c6x-upstreaming.git
> 
> TIA for any feedback and/or guidance on this port.

Hi,

Please run the patches thru checkpatch.pl.  You don't have to fix everything
that it whines about, just use good judgment.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
