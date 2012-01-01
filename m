Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab2AAEYB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 23:24:01 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:47664 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab2AAEX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 23:23:59 -0500
Date: Sat, 31 Dec 2011 23:23:45 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.2.0-rc5 oops in ext4
Message-ID: <20120101042345.GA22312@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Steinar H. Gunderson" <sgunderson@bigfoot.com>,
	linux-kernel@vger.kernel.org
References: <20120101024754.GA14376@uio.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120101024754.GA14376@uio.no>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 01, 2012 at 03:47:58AM +0100, Steinar H. Gunderson wrote:
> Hi,
> 
> During relatively heavy write load, my 3.2.0-rc5 kernel oopsed (after sixteen
> days of uptime, so this is not easily reproducible):

This wasn't the whole kernel oops message.  Can you get any lines
earlier than this?  (Preferably beginning wit
 "-----[ cut here ]-----"?)

     	    			       - Ted
