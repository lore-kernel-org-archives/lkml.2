Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab0DWTOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 15:14:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45353 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab0DWTOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 15:14:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=fCBoCIO8s7OIPOYZ5pUcUBFZLQxeYLMJNHfb6pq4XWXnn9dZPe+Ei0gcLZRxBqtAC2
         MW3C/mMomOxQQk3nXc4Zo7P20xyJkAJYS1h2R7NJs0hc98eLmqQShzwEoJDuTKL7uuGU
         kNoSJy4H4ppa0giCbsG/4+TLw9hyNgDnC5Auo=
Date: Fri, 23 Apr 2010 21:13:42 +0200
From: Dan Carpenter <error27@gmail.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ath5k misbehaving affecting other kernel parts unrelated?
Message-ID: <20100423191342.GI29093@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Pedro Francisco <pedrogfrancisco@gmail.com>,
	linux-kernel@vger.kernel.org
References: <201004230806.13628.pedrogfrancisco@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004230806.13628.pedrogfrancisco@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 08:06:13AM +0100, Pedro Francisco wrote:
> Greetings!
> 
> Is it possible a faulty ath5k module to affect diverse parts of kernel causing 
> different oopses to happen referencing things as different as cdrom_ioctl, 
> find_vma, i915_gem_object_get_pages, get_vfs_caps_from_disk, 
> warn_slowpath_common (ath5k_tasklet_rx), proc_lookup_de and 
> _spin_lock(ext4_getattr) [soft lookup]?
> 

Yes.

A bug a kernel module could corrupt any memory.

If you know a working version of the kernel try a git bisect otherwise
just post your dmesg with the crash etc.

regards,
dan carpenter
