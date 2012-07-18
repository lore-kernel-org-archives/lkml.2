Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab2GRNgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 09:36:36 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:60067 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751070Ab2GRNgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 09:36:32 -0400
Date: Wed, 18 Jul 2012 09:36:20 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Jones <davej@redhat.com>
Subject: Re: [ 01/37] Remove easily user-triggerable BUG from generic_setlease
Message-ID: <20120718133620.GA19712@elliptictech.com>
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
 <20120718001414.GA17973@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120718001414.GA17973@kroah.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 2012-07-17 17:14 -0700, Greg KH wrote:
> Argh, I give up, I just can't get message threading working properly
> these days.  These are the 3.4 patches, in response to the 3.0 patches,
> and it took 2 tries to send them out due to formail doing wierd things.
> 
> Sorry about this people, I'll just give up and use 'git send-email' from
> now on, as it doesn't cause as many problems as my old scripts seem to.

In addition to the threading problems, patch 23/23 from the 3.0-stable
series seems to have never made it to the list.  All the rest are there.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

