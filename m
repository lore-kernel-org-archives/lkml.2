Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137Ab2GLU2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 16:28:47 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47416 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758129Ab2GLU2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 16:28:46 -0400
MIME-Version: 1.0
In-Reply-To: <jtn1c5$q0u$1@dough.gmane.org>
References: <jtn1c5$q0u$1@dough.gmane.org>
From: Drew <drew.kay@gmail.com>
Date: Thu, 12 Jul 2012 13:28:24 -0700
Message-ID: <CACJz6Qsx-xNxDRw5kUqUpf9ogVp23jokHOdGL9xO=kqFXmiNZg@mail.gmail.com>
Subject: Re: Linux RAID subsystem future
To: Zdenek Kaspar <zkaspar82@gmail.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello lists,
>
> I noticed recent patches added MD RAID compatibility into the DM
> subsystem. Is there a valid reason to duplicate efforts ?
>
> Hopefully its not silent preparation step for DM takeover. Can someone
> shed more light on this topic ?
>
> TIA, Z.

I'm not a developer by any stretch of the word so take what I say with
a grain of salt.

I think it's more just a case of dm using md's RAID algorithms, which
IMHO are better tested, to support fakeraid controllers like Intel's
Matrix RAID. Besides, we're all one big happy linux family so why not
borrow your brother's socks? :-)


-- 
Drew
