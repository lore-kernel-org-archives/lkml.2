Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473Ab1D1UPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 16:15:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35104 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab1D1UPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 16:15:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-pgp-id:x-archive
         :user-agent;
        b=IfRn4Iwj9OwnaRysyq//MZqe1IIRuBc/+fzZWtGpFx7bFMmfPSA+2J9K/mkowIECjE
         R1xwVHixLSOg3wU7WoLwvkXGtmMaWS7goRMcw/qh3SZFE6HiLhQepstg6M55O8++p5rQ
         pt641SIc9pF70i1pXKG9ZqyS8admPfvtSnVN4=
Date: Thu, 28 Apr 2011 22:15:27 +0200
From: clemens fischer <ino-news@spotteswoode.dnsalias.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, wlanfae@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8712u: Fix driver to support ad-hoc mode
Message-ID: <20110428201527.GA3738@spotteswoode.de.eu.org>
References: <4db8436a.NDzkd3ql2wJdwy2L%Larry.Finger@lwfinger.net>
 <20110428150819.GA3713@spotteswoode.de.eu.org>
 <4DB9884F.10409@lwfinger.net>
 <BANLkTin7Nw1ZjK8UHfypHXY5ZuzafXnJbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin7Nw1ZjK8UHfypHXY5ZuzafXnJbQ@mail.gmail.com>
X-PGP-ID: 0x214190AF
X-Archive: encrypt=none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jeff Chua:

> iwconfig doesn't work by itself to set adhoc mode (I haven't figure
> why either). You can get into "adhoc mode", but you won't see
> ESSID:XXXX.
> 
> Can you please try "wpa_supplicant" instead?

Well, I never figured out how to configure adhoc-mode using
"wpa_supplicant", could you please send a minimal working config entry?


regards, clemens fischer
