Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab1LLOxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:53:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab1LLOxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:53:35 -0500
Date: Mon, 12 Dec 2011 09:53:30 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
Message-ID: <20111212145330.GB29180@redhat.com>
References: <cover.1322709471.git.psusi@cfl.rr.com>
 <4ED6F320.5060709@cfl.rr.com>
 <20111208123038.GA16493@nb.redhat.com>
 <4EE0C814.2000807@cfl.rr.com>
 <20111208151650.GB16934@nb.redhat.com>
 <4EE0D6E6.9000807@cfl.rr.com>
 <20111208155844.GA9281@redhat.com>
 <4EE0E085.8000907@cfl.rr.com>
 <20111208162847.GB9281@redhat.com>
 <4EE17815.6050806@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE17815.6050806@cfl.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 09:53:09PM -0500, Phillip Susi wrote:
> On 12/08/2011 11:28 AM, Vivek Goyal wrote:
> > I thought I have found couple of places where we don't take mutex. For
> > example.
> 
> I merged your seq changes into my patch.  How does this look?

Can you please inline the patch so that reviewing becomes easier. Right
now it is an attachment.

Couple of quick comments.

- I think during copy/paste tabs have been replaced by spaces at places.
- You have retained function extend_partition() from my patch. I think you
  are not using it.
- Can we rename BLKPG_RES_PARTITION to BLKPG_RESIZE_PARTITION. It is
  easier to read.

Thanks
Vivek
