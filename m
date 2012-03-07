Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475Ab2CGReW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 12:34:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38357 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758938Ab2CGReU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 12:34:20 -0500
MIME-Version: 1.0
In-Reply-To: <20120307154517.GA16080@kroah.com>
References: <1331117396-11600-1-git-send-email-avagin@openvz.org>
	<20120307154517.GA16080@kroah.com>
Date: Wed, 7 Mar 2012 21:34:19 +0400
Message-ID: <CANaxB-yUcg64UxjUSdbNEicnZhBBh_Xx7hPY6DAdb+kA4+AR9w@mail.gmail.com>
Subject: Re: [PATCH] uevent: send events in correct order according to seqnum (v3)
From: Andrew Wagin <avagin@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is this something that you have seen "in the wild"?  If so, we should
> backport it to older kernels as well, right?

Yes, we should. I found this bug in RHEL6, it uses 2.6.32 kernel.

https://bugzilla.redhat.com/show_bug.cgi?id=799834
