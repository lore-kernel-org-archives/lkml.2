Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab1HXTJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 15:09:00 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:56568 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752707Ab1HXTI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 15:08:57 -0400
Subject: Re: [PATCH v2 43/43] ncpfs: Use set_current_blocked()
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Petr Vandrovec <petr@vandrovec.name>,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20110824175216.GA26128@redhat.com>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
	 <1313772419-21951-44-git-send-email-matt@console-pimps.org>
	 <20110824173627.GA18904@redhat.com>  <20110824175216.GA26128@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Aug 2011 20:08:54 +0100
Message-ID: <1314212934.3611.41.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-24 at 19:52 +0200, Oleg Nesterov wrote:
> On 08/24, Oleg Nesterov wrote:
> >
> > Unlless you object, I am going to add the following into the changelog:
> >
> > 	Note: the current code does the strange things which nobody can
> > 	explain, especially the PF_EXITING/SIGKILL thing. This patch does
> > 	try to change this.
> 
> I mean "does not" of course...

Yeah, I think you've got an extra "the" in the first sentence though, it
should say,

	"Note: the current code does strange things..."

But otherwise, yeah, that sounds good to me.

