Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab0CYWnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 18:43:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51752 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab0CYWnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 18:43:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC 13/15] PM / Hibernate: split snapshot_write_next
Date: Thu, 25 Mar 2010 23:46:15 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: jirislaby@gmail.com, pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <1269361063-3341-13-git-send-email-jslaby@suse.cz>
In-Reply-To: <1269361063-3341-13-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201003252346.15608.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 March 2010, Jiri Slaby wrote:
> When reading the snapshot, do the initialization and header read in
> a separate function. This makes the code more readable and lowers
> complexity of snapshot_write_next.

Again, good idea, but the same comments as for the previous patch apply here too.

Rafael
