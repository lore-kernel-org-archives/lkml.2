Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935484Ab2JXSjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:39:09 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57286 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934943Ab2JXSjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:39:07 -0400
Date: Wed, 24 Oct 2012 14:39:04 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: "'Steven J. Magnani'" <steve@digidescorp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.6.0 kernel - ext4 corruption, or?
Message-ID: <20121024183904.GB6142@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Justin Piszcz <jpiszcz@lucidpixels.com>,
	"'Steven J. Magnani'" <steve@digidescorp.com>,
	linux-kernel@vger.kernel.org
References: <1351085817.2362.2.camel@iscandar>
 <002101cdb1e1$47972c60$d6c58520$@lucidpixels.com>
 <20121024144025.GA30955@thunk.org>
 <009201cdb1ff$c33d8c60$49b8a520$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009201cdb1ff$c33d8c60$49b8a520$@lucidpixels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 11:53:47AM -0400, Justin Piszcz wrote:
>
> The problem which we are currently trying to investigate was
> reportedly introduced in v3.6.1.  So far that's about how we know; we
> have two users who have reported it, but I and other ext4 developers
> haven't been able to reproduce it yet.
>
> Got it.

Sorry, typo, we believe that it was introduced in v3.6.2; there were
no ext4-related changes between v3.6 and v3.6.1.

                                         - Ted
