Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab1LNAtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 19:49:19 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37197 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756313Ab1LNAtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 19:49:16 -0500
X-Sasl-enc: rjP+7LqsatMd+oHmJIRtHYOmsHgdByMVD8EViOqRLueA 1323823755
Date: Tue, 13 Dec 2011 16:26:10 -0800
From: Greg KH <greg@kroah.com>
To: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/29] Staging: comedi: fix line over 80 character issue
 in daqboard2000.c
Message-ID: <20111214002610.GA15555@kroah.com>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
 <1323667181-17252-10-git-send-email-ravishankar.km@greenturtles.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323667181-17252-10-git-send-email-ravishankar.km@greenturtles.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 10:49:22AM +0530, Ravishankar karkala Mallikarjunayya wrote:
> This is a patch to the daqboard2000.c file that fixes up a
> line over 80 character warning found by the checkpatch.pl tool.

This doesn't apply without fuzz, so something went wrong, please redo
it.

greg k-h
