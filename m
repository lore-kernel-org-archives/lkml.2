Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab1BNWGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:06:45 -0500
Received: from tundra.namei.org ([65.99.196.166]:52644 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab1BNWGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:06:43 -0500
Date: Tue, 15 Feb 2011 09:06:25 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
cc: Eric Paris <eparis@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 2/2] security: remove unused security_sysctl hook
In-Reply-To: <AANLkTi=WGBDyGpuCjUjuYj=E6HRc80+iunJ_PdXeJq5G@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1102150906050.20521@tundra.namei.org>
References: <1296578542-5902-1-git-send-email-lucian.grijincu@gmail.com> <1296578696-5989-1-git-send-email-lucian.grijincu@gmail.com> <1296587121.12605.30.camel@moss-pluto> <658335B0-9138-4293-9E25-B557AE0DEF7A@redhat.com> <AANLkTimGVCCTVjdw3ODPDGHF9bdJMPUz4JR=1oG86EtF@mail.gmail.com>
 <1297713227.2783.30.camel@unknown001a4b0c2895> <AANLkTi=WGBDyGpuCjUjuYj=E6HRc80+iunJ_PdXeJq5G@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011, Lucian Adrian Grijincu wrote:

> 
> MAINTAINERS says:
> SELINUX SECURITY MODULE
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
> 
> Should It be changed to point to your tree? Or should a new entry be
> added to point to your tree?

That should probably be changed to Eric's tree.

-- 
James Morris
<jmorris@namei.org>
