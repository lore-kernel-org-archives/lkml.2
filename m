Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab0ITNiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 09:38:09 -0400
Received: from tex.lwn.net ([70.33.254.29]:50125 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497Ab0ITNiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 09:38:08 -0400
Date: Mon, 20 Sep 2010 07:38:06 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Stefan Roese <stefan.roese@gmail.com>
Cc: Mathias Krause <minipli@googlemail.com>,
        Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: Re: linux-2.6-stable.git abandoned?
Message-ID: <20100920073806.32e174f4@bike.lwn.net>
In-Reply-To: <201009201535.09341.stefan.roese@gmail.com>
References: <158DE6B2-4FA4-4213-A63F-76BC94D539D9@googlemail.com>
	<20100920071800.49ef5e19@bike.lwn.net>
	<201009201535.09341.stefan.roese@gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010 15:35:08 +0200
Stefan Roese <stefan.roese@gmail.com> wrote:

> Hmmm, looking at:
> 
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6-stable.git;a=summary
> 
> The last change went 3 weeks ago into this git repository.

Try:

	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.34.y.git

if you want 2.6.34 updates.

jon
