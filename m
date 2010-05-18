Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab0ERTzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 15:55:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43241 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab0ERTzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 15:55:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ivan Bulatovic <combuster@gmx.com>
Subject: Re: What is 2.6.34-git1 and how to it it? And whether to eat it?
Date: Tue, 18 May 2010 21:56:44 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: piotr@hosowicz.com, linux-kernel@vger.kernel.org
References: <4BF2AE0A.6010406@example.com> <1274196123.5720.158.camel@localhost.localdomain>
In-Reply-To: <1274196123.5720.158.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005182156.44518.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 May 2010, Ivan Bulatovic wrote:
> No, 2.6.34-git1 is set of patches that eventually will become 2.6.34.1

Not quite.

2.6.34-git1 contains changes that will appear in 2.6.35 (if they are not
reverted in the meantime), but not necessarily in 2.6.34.1.

The only changes from 2.6.34-git1 that will go into 2.6.34.1 are important bug
fixes.

Thanks,
Rafael
