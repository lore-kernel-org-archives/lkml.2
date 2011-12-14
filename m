Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab1LNAty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 19:49:54 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39386 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756249Ab1LNAtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 19:49:51 -0500
X-Sasl-enc: +VBknqHdOO+oF7O/tosy+71Y5GxZo8v2iD1qvqfoRSia 1323823790
Date: Tue, 13 Dec 2011 16:29:52 -0800
From: Greg KH <greg@kroah.com>
To: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/29] Staging: comedi: fix brace coding style issue in
 ni_at_a2150.c
Message-ID: <20111214002952.GA8213@kroah.com>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
 <1323667181-17252-15-git-send-email-ravishankar.km@greenturtles.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323667181-17252-15-git-send-email-ravishankar.km@greenturtles.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 10:49:27AM +0530, Ravishankar karkala Mallikarjunayya wrote:
> This is a patch to the ni_at_a2150.c file that fixes up a brace
> warning found by the checkpatch.pl tool.

No it doesn't.

> Converted printks to dev_<levels>.

It does this.

Ugh, reviewing your patches is hard when you do stuff like this, come
on, be more careful...

I can't accept this.

greg k-h
