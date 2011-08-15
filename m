Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab1HOU5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:57:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab1HOU5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:57:42 -0400
Date: Mon, 15 Aug 2011 16:56:53 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [00/90] 3.0.2-stable review
Message-ID: <20110815205653.GA13895@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <gregkh@suse.de>,
	Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
	stable@kernel.org, stable-review@kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk
References: <20110812210626.GA4725@kroah.com>
 <4E47A400.1030607@gmail.com>
 <20110814161842.GA7864@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110814161842.GA7864@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 09:18:42AM -0700, Greg KH wrote:
 > On Sun, Aug 14, 2011 at 12:31:28PM +0200, Jiri Slaby wrote:
 > > On 08/12/2011 11:06 PM, Greg KH wrote:
 > > > This is the start of the stable review cycle for the 3.0.2 release.
 > > > There are 90 patches in this series, all will be posted as a response
 > > > to this one.
 > > 
 > > It looks like they didn't go through to LKML. Neither for 3.0.2, nor for
 > > .32.45, nor for .33.18. Could you resend?
 > 
 > Sorry, none of them got sent, that was my fault.  I've now sent them
 > all.

Seems to be missing aba8d056078e47350d85b06a9cabd5afcc4b72ea
which is CVE-2011-2905

	Dave

