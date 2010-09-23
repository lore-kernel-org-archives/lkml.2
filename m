Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab0IWWfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:35:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab0IWWff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:35:35 -0400
Date: Thu, 23 Sep 2010 18:35:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-m68k@vger.kernel.org
Cc: hch@lst.de
Subject: Re: [RFT PATCH] amiga, atari floppy: Use one request queue per disk
Message-ID: <20100923223530.GA5658@redhat.com>
References: <1285271646-2768-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285271646-2768-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 03:54:04PM -0400, Vivek Goyal wrote:
> 
> Hi,
> 
> We seem to have deprecated the notion of sharing request queue across gendisks. Now we need to instanciate one request queue per disk.
> 
> There see to be still some drivers sharing request queue across disks. Arch
> specific floppy drivers like amiga and atari are doing so.
> 
> These are two patches which should fix the issue. But these patches are
> completely untested. Not even compilte tested. Don't have hardware to test
> them. 
> 
> Would be great if somebody who has the hardware can lend a hand here to
> see if these patches work.

Sending this mail to linux-m68k@lists.linux-m68k.org list, incase somebody
can help there with testing.

Vivek
