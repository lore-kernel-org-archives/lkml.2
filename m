Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab2GZPV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:21:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35667 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2GZPVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:21:25 -0400
Date: Thu, 26 Jul 2012 10:21:21 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Cc: Arend van Spriel <arend@broadcom.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Problem with commit
 cf03c5dac83609f09d9f0e9fa3c09d86daed614d
Message-ID: <20120726152121.GB10452@thinkpad-t410>
Mail-Followup-To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
	Arend van Spriel <arend@broadcom.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <gik3xqtzw3.fsf@karga.hank.lab>
 <20120726134926.GA10452@thinkpad-t410>
 <gi7gtqlfw2.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gi7gtqlfw2.fsf@mx10.gouders.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 05:07:57PM +0200, Dirk Gouders wrote:
> Hi Seth,
> 
> thanks for your reply and sorry for the noise.
> 
> I followed your advice and tried to boot with the WLAN interface turned
> off, and the problem still exists.  I'll start a new bisect session,
> probably with one of the commits you mentioned as the first good commit.

Just to make sure three's not any confusion ...

What I was suggesting was not just disabling the network interface but
completely preventing brcmsmac from being loaded. The oops you saw
happens in the context of the driver's probe function and would happen
regardless of whether or not the interface is enabled.

Seth

