Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab0CYVX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 17:23:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51503 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab0CYVXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 17:23:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC 04/15] PM / Hibernate: move the first_sector out of swsusp_write
Date: Thu, 25 Mar 2010 22:26:48 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: Jiri Slaby <jslaby@suse.cz>, jirislaby@gmail.com,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <1269361063-3341-4-git-send-email-jslaby@suse.cz> <20100324203125.GF5798@elf.ucw.cz>
In-Reply-To: <20100324203125.GF5798@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003252226.48599.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 March 2010, Pavel Machek wrote:
> On Tue 2010-03-23 17:17:32, Jiri Slaby wrote:
> > From: Jiri Slaby <jirislaby@gmail.com>
> > 
> > The first sector knowledge is swap only specific. Move it into the
> > handle. This will be needed for later non-swap specific code moving
> > inside snapshot.c.
> > 
> > Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> > Cc: Nigel Cunningham <ncunningham@crca.org.au>
> > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> 
> Seems ok. ACK.

Yes, it looks good.

Rafael
