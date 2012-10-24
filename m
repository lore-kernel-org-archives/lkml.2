Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935036Ab2JXOki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:40:38 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57222 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934903Ab2JXOkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:40:37 -0400
Date: Wed, 24 Oct 2012 14:40:25 +0000
From: tytso@mit.edu
To: Justin Piszcz <jpiszcz@lucidpixels.com>,
        "Steven J. Magnani" <steve@digidescorp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.6.0 kernel - ext4 corruption, or?
Message-ID: <20121024144025.GA30955@thunk.org>
Mail-Followup-To: tytso@mit.edu, Justin Piszcz <jpiszcz@lucidpixels.com>,
	"Steven J. Magnani" <steve@digidescorp.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351085817.2362.2.camel@iscandar>
 <002101cdb1e1$47972c60$d6c58520$@lucidpixels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 08:15:37AM -0400, Justin Piszcz wrote:
> 
> I read there was a bug in 3.6.2, is there also one in 3.6.0, or can someone
> help explain this?

The problem which we are currently trying to investigate was
reportedly introduced in v3.6.1.  So far that's about how we know; we
have two users who have reported it, but I and other ext4 developers
haven't been able to reproduce it yet.

> # grep 10.0.0.11 -r /etc
> /etc/posfix.old/master.cf:10.0.0.11:smtp         inet  n       -       -
> -        1    postscreen
> 
> # ls -l /etc/posfix.old/master.cf
> -rw-r--r-- 1 root root 13236 Oct 28  2011 /etc/posfix.old/master.cf
> 
> # ls -ld /etc/postfix.old
> ls: cannot access /etc/postfix.old: No such file or directory
> 

Looks like you or some script renamed /etc/postfix to /etc/posfix.old
as part some upgrade?

      	       	       	      	      		   - Ted

