Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab1LFAmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 19:42:46 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38645 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752Ab1LFAmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 19:42:45 -0500
Date: Mon, 5 Dec 2011 22:41:54 -0200 (BRST)
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
X-X-Sender: marcos@cactuar.localhost
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Marcos Paulo de Souza <marcos.mage@gmail.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/2] staging: vt6656: aes_ccmp, baseband, bssdb, card:
 Change BOOL to int
In-Reply-To: <20111205065517.GC3236@mwanda>
Message-ID: <alpine.LNX.2.00.1112052237140.2379@cactuar.localhost>
References: <1323047566-12650-1-git-send-email-marcos.mage@gmail.com> <20111205065517.GC3236@mwanda>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Dec 2011, Dan Carpenter wrote:
> On Sun, Dec 04, 2011 at 11:12:46PM -0200, Marcos Paulo de Souza wrote:
>> This patch change all references of BOOL to int. As asked by the TODO
>> file of the driver, we need to remove the ttype.h, and this file do a
>> typedef of int to BOOL. We don't need this.

Dan, I'm trying to remove this chunk of code:

drivers/staging/vt6656/ttype.h:

typedef int BOOL;

Are we talinkg about the same BOOL type?

>
> Why not use bool?  Especially inside structs bool takes up less
> space than an int.  Also static analysis tools care about the type.

This typedef is about a int type.

> Changing the type from int to bool is a code change so it needs
> careful auditing.  It's not a problem if you don't have this
> hardware, but you've been sending quite a few patches for it, so I'm
> curious if you do?  If you did, and you made a code change then it
> helps us to know if you have tested it.

I made just compile test, and my doubt if this BOOL typedef is same as you 
are talinkg about.

If this BOOL don't "break" any architeture, I will be happy to remove all 
of it from vt6656 and vt6655, both with the same horrible ttype.h file.

Thanks for the comments.

Regards,

Marcos Paulo de Souza

> regards,
> dan carpenter
>
>
