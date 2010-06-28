Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab0F1JIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 05:08:45 -0400
Received: from smtp-out.google.com ([74.125.121.35]:28722 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab0F1JIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 05:08:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=iq8po4OLiT4eZUeCPwDA7QjCddWfbBdLEC8/66vm6cPNn5PBKaZs3KWaI1uUEY6/z
	yAYdRuO7F8f1/ToJmHF2A==
Date: Mon, 28 Jun 2010 02:08:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Amerigo Wang <amwang@redhat.com>
cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/2] Makefile: fix missing dash when using make
 LOCALVERSION=xxx
In-Reply-To: <20100628030507.5187.95903.sendpatchset@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1006280207580.28072@chino.kir.corp.google.com>
References: <20100628030507.5187.95903.sendpatchset@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jun 2010, Amerigo Wang wrote:

> From: Amerigo Wang <amwang@redhat.com>
> Date: Mon, 28 Jun 2010 10:42:28 +0800
> 
> When I use make LOCALVERSION=local and LOCALVERSION_AUTO is not set,
> I got "2.6.35-rc3local". It is supposed to be "2.6.35-rc3-local".
> 

No, a `-' is not implied when using LOCALVERSION=.
