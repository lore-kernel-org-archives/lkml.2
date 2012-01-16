Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab2APFv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 00:51:59 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:58857 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751074Ab2APFv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 00:51:58 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/WERl4Vq/W2RR8TTzQYxdj5fsB3Xm46fi64c8cLX
	Op8rWmqfToQNFf
Subject: Re: Chronic resource starvation.
From: Mike Galbraith <efault@gmx.de>
To: Mike Mestnik <cheako@mikemestnik.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4F13B902.1090503@mikemestnik.net>
References: <4F10F3AE.3030801@mikemestnik.net>
	 <4F11E3B8.6090007@mikemestnik.net>
	 <1326629295.6352.14.camel@marge.simson.net>
	 <4F1322A6.7090009@mikemestnik.net>
	 <1326681574.6446.25.camel@marge.simson.net>
	 <4F13B902.1090503@mikemestnik.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jan 2012 06:51:54 +0100
Message-ID: <1326693114.6446.158.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-01-15 at 23:43 -0600, Mike Mestnik wrote:

> Ahhh, as I had suspected I'm not the only one.

Far from it, IO related stalls have come up many times over the years.

> Does fdatasync still cause this problem?  I'm sure there must be
> some way to 'group' applications together that should be allowed to
> avoid this effect and even insert IO requests during the operation if
> given a high enough priority.

A lot of work was done, and it improved things a LOT, but beating hell
out of your interactive application's home has always been a bad idea,
and will likely always be so.

	-Mike

