Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab0DKULc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 16:11:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47823
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228Ab0DKULb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 16:11:31 -0400
Date: Sun, 11 Apr 2010 13:11:32 -0700 (PDT)
Message-Id: <20100411.131132.193718466.davem@davemloft.net>
To: James.Bottomley@suse.de
Cc: ebiederm@xmission.com, gregkh@suse.de, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: Add lockdep annotations to SAS sysfs
 attributes.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1270989312.2806.644.camel@mulgrave.site>
References: <20100410.214017.165974351.davem@davemloft.net>
	<1270989312.2806.644.camel@mulgrave.site>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@suse.de>
Date: Sun, 11 Apr 2010 07:35:12 -0500

> On Sat, 2010-04-10 at 21:40 -0700, David Miller wrote:
>> They are allocated dynamically, and thus need sysfs_attr_init()
>> treatment.
> 
> This should all be taken care of by
> 
> commit ebd09ec93c90c8ec571d7e166832fb1fc705bf5e
> Author: James Bottomley <James.Bottomley@suse.de>
> Date:   Sat Mar 20 12:44:12 2010 -0500

Thanks, that should take care of it, my sparc-2.6 tree hadn't
sync'd with Linus's tree in a while. :-)

