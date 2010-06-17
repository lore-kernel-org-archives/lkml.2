Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907Ab0FQPFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 11:05:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:47640 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760211Ab0FQPFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 11:05:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VYyKKE+j4/8MR8Lzmgb2nnxdALpDkUQD3rWUEg/ahVSLan71rgLG001dvMPMkzHAls
         f3GjMsfnwjhJiFNmR5UXjVetfYCnyW3zbgLbzF10+h9u0WH+3EEVwvGKwYULsOiWicz/
         p7WjcNV8WHuNKHQfa8gl2OoujrGpWezSXv4Co=
Subject: Re: mpd client timeouts (bisected) 2.6.35-rc3
From: Christoph Fritz <chf.fritz@googlemail.com>
To: "markus@trippelsdorf.de" <markus@trippelsdorf.de>
Cc: John Fastabend <john.r.fastabend@intel.com>,
       David Miller <davem@davemloft.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, alex.shi@intel.com, tim.c.chen@intel.com
In-Reply-To: <20100613205922.GA1806@arch.tripp.de>
References: <20100612102802.GA1782@arch.tripp.de>
	 <20100612.145835.123986343.davem@davemloft.net>
	 <4C149147.3080808@intel.com> <4C15414E.5090201@intel.com>
	 <20100613205922.GA1806@arch.tripp.de>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 17 Jun 2010 17:05:11 +0200
Message-ID: <1276787111.2970.1.camel@lovely.krouter>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-13 at 22:59 +0200, markus@trippelsdorf.de wrote:
> On Sun, Jun 13, 2010 at 01:36:30PM -0700, John Fastabend wrote:

> > [PATCH] net: fix deliver_no_wcard regression on loopback device
> 
> This solves the problem here. Thanks.

here too

Tested-by: Christoph Fritz <chf.fritz@googlemail.com>


