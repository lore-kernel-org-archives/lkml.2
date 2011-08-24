Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab1HXRzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 13:55:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651Ab1HXRzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:55:18 -0400
Date: Wed, 24 Aug 2011 19:52:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Petr Vandrovec <petr@vandrovec.name>,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 43/43] ncpfs: Use set_current_blocked()
Message-ID: <20110824175216.GA26128@redhat.com>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org> <1313772419-21951-44-git-send-email-matt@console-pimps.org> <20110824173627.GA18904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824173627.GA18904@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24, Oleg Nesterov wrote:
>
> Unlless you object, I am going to add the following into the changelog:
>
> 	Note: the current code does the strange things which nobody can
> 	explain, especially the PF_EXITING/SIGKILL thing. This patch does
> 	try to change this.

I mean "does not" of course...

Oleg.

