Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab1ERVak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:30:40 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:48796 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755021Ab1ERVah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:30:37 -0400
X-Sasl-enc: lpviiaumXftkhvSzkItJeZGXNYwcv0JyDZOZM6IwiPn3 1305754236
Date: Wed, 18 May 2011 14:29:27 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Brett Rudley <brudley@broadcom.com>, Henry Ptasinski <henryp@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Dowan Kim <dowan@broadcom.com>,
        Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: brcm80211: brcmfmac: Add and use dhd_dbg
Message-ID: <20110518212927.GB13555@kroah.com>
References: <60c19c2ad4f078b6f283b5ff4ecca3653833ea28.1305742868.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60c19c2ad4f078b6f283b5ff4ecca3653833ea28.1305742868.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 11:23:21AM -0700, Joe Perches wrote:
> All uses of DHD_<TYPE> macros are for debugging only.
> 
> Change the multiple uses of DHD_<TYPE>((...)) to dhd_dbg(TYPE, ...)
> for a more consistent style.

I need an ack from one of the broadcom developers before I can take this
patch...

thanks,

greg k-h
