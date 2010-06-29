Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0F2JcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 05:32:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55777 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284Ab0F2JcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 05:32:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=bCgI0Dg0ZkJUIvdXRHMy+MUnmnacl+aGauHFN/SGA+tzbMMqiVm/y174ee0VwYUz12
         ZqVoIXqa5XszAvE3yWqP40JASGejD9MXiv31in3il+iQeyLlcU45A+2QNgaJ5z6wuOWB
         AK6PdrBWZLYKgJmblxR5DfdM7KIuVPtbCDV9w=
Date: Tue, 29 Jun 2010 12:07:42 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: David Miller <davem@davemloft.net>, ospite@studenti.unina.it,
       alan@signal11.us, marcel@holtmann.org, mdpoole@troilus.org,
       hadess@hadess.net, eric.dumazet@gmail.com,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] Bluetooth: hidp: Add support for hidraw
 HIDIOCGFEATURE and HIDIOCSFEATURE
Message-ID: <20100629090742.GA2716@jh-x301>
Mail-Followup-To: Jiri Kosina <jkosina@suse.cz>,
	David Miller <davem@davemloft.net>, ospite@studenti.unina.it,
	alan@signal11.us, marcel@holtmann.org, mdpoole@troilus.org,
	hadess@hadess.net, eric.dumazet@gmail.com,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
References: <1276467601-9066-1-git-send-email-alan@signal11.us>
 <20100628131437.bde782b6.ospite@studenti.unina.it>
 <20100629.001216.91341775.davem@davemloft.net>
 <alpine.LNX.2.00.1006291047560.13809@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1006291047560.13809@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 29, 2010, Jiri Kosina wrote:
> Frankly, I don't understand what exactly the current situation with 
> in-kernel bluetooth stack is anyway. 
> 
> What is the relation between what we have in net/bluetooth and the tree at 
> [1], which seems to be quite actively developed?

The difference is that the userspace part has essentially two
maintainers (me and Marcel) whereas the kernel side only has one
(Marcel). So even when Marcel is inactive I can at least take care of
the userspace side. I'd volunteer for the kernel also but I don't really
have any experience there (only 3-4 patches so far).

Johan
