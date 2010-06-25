Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab0FYNim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:38:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49152 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581Ab0FYNik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:38:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 4/9] PM / Hibernate: user, implement user_ops reader
Date: Fri, 25 Jun 2010 15:37:06 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
References: <1275468768-28229-1-git-send-email-jslaby@suse.cz> <1275468768-28229-4-git-send-email-jslaby@suse.cz>
In-Reply-To: <1275468768-28229-4-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201006251537.06601.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 02, 2010, Jiri Slaby wrote:
> Switch /dev/snapshot writer to hibernate_io_ops approach so that we
> can do whatever we want with snapshot processing code. All the later
> code changes will be transparent and needn't care about different
> readers/writers.
> 
> In this patch only reader is implemented, writer was done previously.
> 
> It works similarly to writer, CONSUMER here is snapshot layer,
> PRODUCER is fops->write.

Here, I have pretty much the same comment as for [3/9].  I don't really think
it's necessary or even useful to change the s2disk code paths.

> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> ---

Rafael
