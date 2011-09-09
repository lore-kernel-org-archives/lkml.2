Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441Ab1IIRAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 13:00:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55478 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758985Ab1IIRAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 13:00:45 -0400
Date: Fri, 9 Sep 2011 10:00:15 -0700
From: Dan Carpenter <error27@gmail.com>
To: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Staging: comedi: fix printk issue in pcmuio.c
Message-ID: <20110909170015.GG17041@mwanda>
References: <1315506084-2959-1-git-send-email-ravishankar.km@greenturtles.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315506084-2959-1-git-send-email-ravishankar.km@greenturtles.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This still has KERN_ERR and KERN_INFO tags in the middle of the line.

Your patches mostly are buggy.  Please can you stop sending patches
that haven't been tested?  Otherwise, you're just not careful enough
about not introducing bugs.  (Other people are normally more careful
than you are).

regards,
dan carpenter

