Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab0D1WPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 18:15:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53655 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492Ab0D1WPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 18:15:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 1/5] FS: libfs, implement simple_write_to_buffer
Date: Thu, 29 Apr 2010 00:16:40 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
References: <1272356118-10012-1-git-send-email-jslaby@suse.cz> <201004272358.36175.rjw@sisk.pl>
In-Reply-To: <201004272358.36175.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201004290016.40469.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 April 2010, Rafael J. Wysocki wrote:
> On Tuesday 27 April 2010, Jiri Slaby wrote:
> > It will be used in suspend code and serves as an easy wrap around
> > copy_from_user. Similar to simple_read_from_buffer, it takes care
> > of transfers with proper lengths depending on available and count
> > parameters and advances ppos appropriately.
> > 
> > Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> > Cc: Nigel Cunningham <ncunningham@crca.org.au>
> > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > Cc: linux-fsdevel@vger.kernel.org
> 
> Thanks for the patches, I'll review them as soon as I can.

They look good.  If there are no objections from the other people, I'll add
them to suspend-2.6/linux-next in the next few days.

Rafael
