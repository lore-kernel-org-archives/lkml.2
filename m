Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2A3BJK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 20:09:10 -0500
Received: from tundra.namei.org ([65.99.196.166]:42338 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab2A3BJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 20:09:08 -0500
Date: Mon, 30 Jan 2012 12:09:05 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: John Johansen <john.johansen@canonical.com>
cc: Kees Cook <kees@ubuntu.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] AppArmor: refactor securityfs to use structures
In-Reply-To: <4F22FD36.6020309@canonical.com>
Message-ID: <alpine.LRH.2.00.1201301208590.28850@tundra.namei.org>
References: <1327624163-21576-1-git-send-email-kees@ubuntu.com> <4F22FD36.6020309@canonical.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jan 2012, John Johansen wrote:

> On 01/26/2012 04:29 PM, Kees Cook wrote:
> > This is the ground-work for expanding the AppArmor securityfs to include
> > useful information that the userspace tools can more easily interact with.
> > Presently, this is only static information about the state of AppArmor.
> > 
> James,
> 
> if no one else has issues with these, I will pull these patches into the
> apparmor tree to batch them together as pull request with some other
> apparmor patches

Great.


-- 
James Morris
<jmorris@namei.org>
