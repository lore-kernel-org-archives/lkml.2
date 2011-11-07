Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab1KGQ3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:29:45 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55099 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271Ab1KGQ3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:29:44 -0500
Message-ID: <1320683377.10093.3.camel@localhost>
Subject: Re: suspicious RCU usage in security/selinux/netport.c:127
From: Eric Paris <eparis@parisplace.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>
Date: Mon, 07 Nov 2011 11:29:37 -0500
In-Reply-To: <20111107162531.GA28795@redhat.com>
References: <20111107162531.GA28795@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-07 at 11:25 -0500, Dave Jones wrote:
> I think I reported this a while ago. Turns out it's still a problem.
> This patch I think made the warning go away, but it might be a bit too 'big hammer' ?

http://patchwork.ozlabs.org/patch/117821/

I thought it was already picked up.  I'll take care of it today.

-Eric

