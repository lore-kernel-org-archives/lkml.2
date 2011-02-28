Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab1B1MXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 07:23:06 -0500
Received: from pqueueb.post.tele.dk ([193.162.153.10]:38296 "EHLO
	pqueueb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab1B1MXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 07:23:05 -0500
Date: Mon, 28 Feb 2011 13:22:36 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Waychison <mikew@google.com>, klibc@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [klibc] [PATCH] build: Define __EXPORTED_HEADER__
Message-ID: <20110228122236.GA1211@merkur.ravnborg.org>
References: <1298506377-16796-1-git-send-email-mikew@google.com> <201102272107.48934.arnd@arndb.de> <AANLkTikijjZwQp6Fer9TqRqQe=2WhSCPcDv5mczcGD8g@mail.gmail.com> <201102281311.16811.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102281311.16811.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 01:11:16PM +0100, Arnd Bergmann wrote:
> On Monday 28 February 2011, Mike Waychison wrote:
> > How is one expected to test if the files should be rebuild or not?
> > Forcing a headers_install as part of a build will cause the entire
> > userland to be rebuilt.
> 
> How about changing headers_install to only install files that have
> changed? Make headers_install alreadh knows the list of all files
> it is installing.

make headers_install already does so. Only changes fiels are updated.
So I consider this a non-issue.

	Sam
