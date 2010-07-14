Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab0GNXBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 19:01:07 -0400
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:44918 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757299Ab0GNXBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 19:01:03 -0400
Date: Thu, 15 Jul 2010 01:01:00 +0200
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Ed W <lists@wildgooses.com>
Cc: David Miller <davem@davemloft.net>, rick.jones2@hp.com, davidsen@tmr.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Raise initial congestion window size / speedup slow start?
Message-ID: <20100714230100.GL6682@nuttenaction>
References: <4C3E0684.5060409@wildgooses.com>
 <4C3E1B54.40604@hp.com>
 <20100714203919.GD6682@nuttenaction>
 <20100714.145547.102555471.davem@davemloft.net>
 <20100714221301.GI6682@nuttenaction>
 <4C3E3F92.2090506@wildgooses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3E3F92.2090506@wildgooses.com>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ed W | 2010-07-14 23:52:02 [+0100]:

>Out of curiousity, why has it taken so long for active feedback to
>appear?  If every router simply added a hint to the packet as to the
>max bandwidth it can offer then we would appear to be able to make
>massively better decisions on window sizes.  Furthermore routers have
>the ability to put backpressure on classes of traffic as appropriate.
>I guess the speed at which ECN has been adopted answers the question
>of why nothing more exotic has appeared?

It is quite late here so I will quickly write two sentence about ECN: one
month ago Lars Eggers posted a link at the tcpm maillinglist where google (not
really sure if it was google) analysed the employment of ECN - the usage was
really low. Search the PDF, it is quite interesting one.

Hagen


