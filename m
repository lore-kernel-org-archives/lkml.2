Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab0GGNy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:54:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54393 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab0GGNy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:54:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] scsi/sd: remove big kernel lock
Date: Wed, 7 Jul 2010 15:54:38 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org,
       "James E.J. Bottomley" <James.Bottomley@suse.de>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de> <1278193640-24223-7-git-send-email-arnd@arndb.de> <20100707020623.GA28839@infradead.org>
In-Reply-To: <20100707020623.GA28839@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007071554.38395.arnd@arndb.de>
X-Provags-ID: V02:K0:Vo12/2BvqfYc2Yd85CLfnmdR9WqrUM0vyFYzic7PIA+
 Ab0sG58EcnwJlIpOzNWFkHv0DnCLGrvy3fCEf90Yaljvea0Mel
 O6+JxZgP1w3wIB+36cM0uZr1BI2tn2pUtT0ccM6qQefCMXryd6
 VJF1IgdLx/sU7L4ZLzmj0BlIVvE1LSacbXoykxHCgFIinlNT/2
 KiE5mxVruIX64Ua0LC0ww==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 July 2010, Christoph Hellwig wrote:
> 
> This looks fine, although relying on the bd_mutex held in the caller
> for ->openers seems a bit fragile.  At least add a big comment about
> this fact.

Ok, added the comment.

	Arnd
