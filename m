Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab2LYEKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 23:10:06 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:59272 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab2LYEKE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 23:10:04 -0500
Date: Mon, 24 Dec 2012 22:10:00 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: USB 2.0 (EHCI) keeps crapping out (3.2.29)
To: Logan Rathbone <loganrathbone@gmail.com>
Cc: linux-kernel@vger.kernel.org
References: <50D91733.2040000@gmail.com>
In-Reply-To: <50D91733.2040000@gmail.com> (from loganrathbone@gmail.com on
	Mon Dec 24 21:02:11 2012)
X-Mailer: Balsa 2.4.11
Message-Id: <1356408600.31232.2@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2012 09:02:11 PM, Logan Rathbone wrote:
> *** NOTE:  Kindly CC me directly if you reply to list since I'm not  
> an LKML subscriber. ***
> 
> Running vanilla 3.2.29 (Slackware 14.0).  I also had this issue on  
> 2.6.37.6 and *possibly* 2.6.33.x, but I don't recall.
> 
> Every now and again (could be every few days, could take a couple of  
> weeks...
> depends.) USB 2.0 stops working.  My scanner as well as certain  
> mass-storage
> devices that are USB-2.0 compatible fail to function all of a sudden.
> 
> With the said mass storage devices, I get lots of errors like this in  
> my logs:
> 
> hub 1-0:1.0: unable to enumerate USB device on port 3

What is the _first_ error that shows up in dmesg when the failure  
occurs?

Rob