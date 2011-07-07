Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab1GGVfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 17:35:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36746 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab1GGVfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 17:35:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch 1/1] [PATCH] include storage keys in hibernation image.
Date: Thu, 7 Jul 2011 23:36:25 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Jiri Slaby <jslaby@suse.cz>, Len Brown <lenb@kernel.org>
References: <20110608074523.211912903@de.ibm.com> <201106142250.15041.rjw@sisk.pl> <20110615093629.07f01779@mschwide>
In-Reply-To: <20110615093629.07f01779@mschwide>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107072336.26151.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 15, 2011, Martin Schwidefsky wrote:
> On Tue, 14 Jun 2011 22:50:14 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
...
> 
> Well before the preallocation kicked in we don't know which are the relevant
> storage keys. The only other option would be to store all of them which I
> consider to be a inferior solution. 

I've been thinking about that recently a bit.

Don't we need to restore the keys of the page frames that aren't copied
into the image too?

Rafael
