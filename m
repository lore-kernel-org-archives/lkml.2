Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab2ECPw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:52:59 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53596 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753807Ab2ECPw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:52:58 -0400
Message-ID: <1336060376.13866.6.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: add check for whitespace before semicolon
 at end-of-line
From: Joe Perches <joe@perches.com>
To: Eric Nelson <eric.nelson@boundarydevices.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        u-boot@lists.denx.de, rylv50@freescale.com, marex@denx.de,
        vapier@gentoo.org
Date: Thu, 03 May 2012 08:52:56 -0700
In-Reply-To: <4FA28AF4.1000205@boundarydevices.com>
References: <http://lists.denx.de/pipermail/u-boot/2012-May/123595.html>
	 <1336015938-3174-1-git-send-email-eric.nelson@boundarydevices.com>
	 <1336017507.13866.2.camel@joe2Laptop>
	 <4FA28AF4.1000205@boundarydevices.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 06:41 -0700, Eric Nelson wrote:
> >> +# check for whitespace before semicolon - not allowed at end-of-line
> >> +		if ($line =~ /\s+;$/) {
> >
> > 		if ($line =~ /\s+;\s*$/)

> Won't the extra space at end of line be caught by other tests?

Yes it will.

You want the test to find the space before semicolon
whenever it exists.


