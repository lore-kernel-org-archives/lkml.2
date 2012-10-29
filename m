Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab2J2Htu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 03:49:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab2J2Htt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 03:49:49 -0400
Date: Mon, 29 Oct 2012 08:49:41 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support 
In-Reply-To: <1348152065-31353-1-git-send-email-mjg@redhat.com>
Message-ID: <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2012, Matthew Garrett wrote:

> This is pretty much identical to the first patchset, but with the capability
> renamed (CAP_COMPROMISE_KERNEL) and the kexec patch dropped. If anyone wants
> to deploy these then they should disable kexec until support for signed
> kexec payloads has been merged.

Apparently your patchset currently doesn't handle device firmware loading, 
nor do you seem to mention in in the comments.

I believe signed firmware loading should be put on plate as well, right?

Thanks,

-- 
Jiri Kosina
SUSE Labs

