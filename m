Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab1CIJGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:06:30 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54203 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab1CIJG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:06:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=fgBJm7d/xAcchBystS6yhm+PylX7uEblbieTZbqIMcDND0joVgv6dI0y7+FMOjX/fP
         rB1sVp+5OYBRzJTUiyamwdQdyspsL1V2XUrF9iqbbqZuxrouotQFG78N3jdl3VvVbvL7
         snUTe9jezihPzPxcO5VlcSzJs5KJ6LYUknW6E=
Date: Wed, 9 Mar 2011 10:06:22 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: MD-raid broken in 2.6.37.3?
Message-ID: <20110309090622.GA3570@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg and Neil,

I updated from 2.6.37.2 to 2.6.37.3 yesterday only to find that my
raid-0 partitions are no longer recognised. The raid-1 ones still are,
though. They did not show up after a reboot. (It has happened once
fairly recently that these exact partitions were not recognised but a
reboot fixed it -- blamed my disks.)

Today I mistakenly booted into 2.6.37.3 again -- still missing. No
problems with 2.6.37.2.

Browsing the changelog I found f663ed60892c3e1d4490b079a45d9e546271c40c
(md: Fix - again - partition detection when array becomes active) and
other md-related changes so I figure one of these could perhaps be to
blame?

As it is my personal/production machine I feel uncomfortable bisecting
this at this point, but maybe Neil has an idea of what might be going
on?

Thanks,
Johan
