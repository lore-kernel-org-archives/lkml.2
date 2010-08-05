Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139Ab0HEK1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 06:27:38 -0400
Received: from tundra.namei.org ([65.99.196.166]:45941 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760109Ab0HEK1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 06:27:30 -0400
Date: Thu, 5 Aug 2010 20:27:24 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Pavel Machek <pavel@ucw.cz>
cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [AppArmor #7 0/13] AppArmor security module
In-Reply-To: <20100805062431.GA1546@ucw.cz>
Message-ID: <alpine.LRH.2.00.1008052023030.14772@tundra.namei.org>
References: <1280440089-3203-1-git-send-email-john.johansen@canonical.com> <alpine.LRH.2.00.1007300903440.7719@tundra.namei.org> <20100805062431.GA1546@ucw.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Aug 2010, Pavel Machek wrote:

> > Note that I added the patch below to update AA against the latest 
> > version of path_truncate:
> 
> Ok, so now we have two name-based "security" modules. Can we at least
> drop TOMOYO? That seems to have all apparmor disadvantages plus some
> more...

No.  The policy is that any security module which implements an access 
control scheme and meets a well-defined security goal, and passes 
technical review, may be merged.

aka, The Arjan Protocol:

http://kerneltrap.org/Linux/Documenting_Security_Module_Intent


-- 
James Morris
<jmorris@namei.org>
