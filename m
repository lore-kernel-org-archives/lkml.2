Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab1ALXFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 18:05:23 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44141 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab1ALXFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 18:05:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vR5jSxDLFcyVMMJUcAELq+crbsK2eq26aS24oZx4SJfZ5ju/BfPC5TZewCbEOcxcic
         COoCF1/yaix+hLbyyNNj7lef3Ln8muLFb1mX5Z9VU7Boe+p5NSPWfhbBubz3QbDTOQ2T
         NbdAElCz7Zer7w1gfc2BtKS5reEUeP8rMsmSk=
Date: Wed, 12 Jan 2011 15:05:14 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Power plug off / on - EXT4-fs (sda1): re-mounted. Opts:
 errors=remount-ro,commit=600
Message-ID: <20110112230513.GA9661@core.coreip.homeip.net>
References: <AANLkTinC=i24FaOtB3srbCUROza1V2TQ0zxNMq+QH+mj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinC=i24FaOtB3srbCUROza1V2TQ0zxNMq+QH+mj@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 01:35:29PM -0800, Luis R. Rodriguez wrote:
> When I yank my power chord off of my Thinkpad T61 running 2.6.37 I get
> the following:
> 
> [   79.523778] Monitor-Mwait will be used to enter C-3 state
> [   81.195402] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=600
> 
> mcgrof@tux ~ $ mount| grep sda1
> /dev/sda1 on / type ext4 (rw,errors=remount-ro,commit=600)
> 
> When I plug the power chord it back in I get:
> 
> [  216.185265] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=0
> 
> mcgrof@tux ~ $ mount | grep sda1
> /dev/sda1 on / type ext4 (rw,errors=remount-ro,commit=0)
> 
> Is this to be expected?
> 

FWIW I do not observe anything like this on Dell Latitude d630.

-- 
Dmitry
