Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200Ab0CPQL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 12:11:57 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:36834 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab0CPQL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 12:11:56 -0400
Date: Tue, 16 Mar 2010 12:11:33 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: locking issue in vhost_net_set_backend
Message-ID: <20100316161133.GA1465@localhost.localdomain>
References: <4B9F8E7F.7070709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9F8E7F.7070709@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 02:58:23PM +0100, Jiri Slaby wrote:
> I don't see how the lock is unlocked on the error paths and as it is not  
> on none of the them maybe I'm missing something?

I sent Michael a patch for this a couple of weeks ago.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
