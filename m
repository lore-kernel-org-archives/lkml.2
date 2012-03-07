Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964919Ab2CGR4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 12:56:18 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34957 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974Ab2CGR4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 12:56:16 -0500
Date: Wed, 7 Mar 2012 09:47:22 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andrew Wagin <avagin@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>
Subject: Re: [PATCH] uevent: send events in correct order according to seqnum
 (v3)
Message-ID: <20120307174722.GA12022@kroah.com>
References: <1331117396-11600-1-git-send-email-avagin@openvz.org>
 <20120307154517.GA16080@kroah.com>
 <CANaxB-yUcg64UxjUSdbNEicnZhBBh_Xx7hPY6DAdb+kA4+AR9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANaxB-yUcg64UxjUSdbNEicnZhBBh_Xx7hPY6DAdb+kA4+AR9w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 09:34:19PM +0400, Andrew Wagin wrote:
> > Is this something that you have seen "in the wild"?  If so, we should
> > backport it to older kernels as well, right?
> 
> Yes, we should. I found this bug in RHEL6, it uses 2.6.32 kernel.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=799834

Great, thanks for letting me know, I'll queue it up for the older
kernels as well.

greg k-h
