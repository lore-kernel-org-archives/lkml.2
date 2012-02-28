Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab2B1AEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:04:54 -0500
Received: from mail.vyatta.com ([76.74.103.46]:46940 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177Ab2B1AEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:04:52 -0500
Date: Mon, 27 Feb 2012 16:04:50 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Andrei Warkentin <andrey.warkentin@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NetKGDB v3
Message-ID: <20120227160450.022784bb@nehalam.linuxnetplumber.net>
In-Reply-To: <1330313411-845-1-git-send-email-andrey.warkentin@gmail.com>
References: <1330137851-4716-1-git-send-email-andrey.warkentin@gmail.com>
	<1330313411-845-1-git-send-email-andrey.warkentin@gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Feb 2012 22:30:08 -0500
Andrei Warkentin <andrey.warkentin@gmail.com> wrote:

> netkgdb is designed to accept connections
> from any hosts, i.e. it is not necessary to specify these ahead
> of time. This makes it that much more useful in a "this host crashed
> and a I want a developer to take a look at it" scenario, common to
> large scale test/QA farms and automated testing harnesses.

And opens a security hole so wide that no production network
or distro should ever enable it!
