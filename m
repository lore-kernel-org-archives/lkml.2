Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab1BIQqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 11:46:42 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:50418 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab1BIQql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 11:46:41 -0500
Subject: Re: [PATCH] btrfs: prevent heap corruption in
 btrfs_ioctl_space_info()
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Josef Bacik <josef@redhat.com>
Cc: chris.mason@oracle.com, security@kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <20110209161654.GB2564@localhost.localdomain>
References: <1297260766.2327.40.camel@dan>
	 <20110209155130.GA2564@localhost.localdomain>
	 <20110209161654.GB2564@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 11:45:24 -0500
Message-ID: <1297269924.11434.26.camel@Dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Argh sorry I take it back, this is wrong, we can have multiple raid types per
> space info, so you need to put the slot_count-- in the inner loop farther down
> to count the actual slots we're adding.  Thanks,
> 

Good catch, thanks.

Reviewed-by: Dan Rosenberg <drosenberg@vsecurity.com>

-Dan

