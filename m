Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909Ab0GNUqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:46:05 -0400
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:44514 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757496Ab0GNUqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:46:00 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jul 2010 16:46:00 EDT
Date: Wed, 14 Jul 2010 22:39:19 +0200
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Rick Jones <rick.jones2@hp.com>
Cc: Ed W <lists@wildgooses.com>, David Miller <davem@davemloft.net>,
        davidsen@tmr.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Raise initial congestion window size / speedup slow start?
Message-ID: <20100714203919.GD6682@nuttenaction>
References: <4C3D94E3.9080103@wildgooses.com>
 <4C3DD5EB.9070908@tmr.com>
 <20100714.111553.104052157.davem@davemloft.net>
 <4C3E0684.5060409@wildgooses.com>
 <4C3E1B54.40604@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3E1B54.40604@hp.com>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rick Jones | 2010-07-14 13:17:24 [-0700]:

>There is an effort under way, lead by some folks at Google and
>including some others, to get the RFC's enhanced in support of the
>concept of larger initial congestion windows.  Some of the discussion
>may be in the "tcpm" mailing list (assuming I've not gotten my
>mailing lists confused).  There may be some previous discussion of
>that work in the netdev archives as well.

tcpm is the right mailing list but there is currently no effort to develop
this topic. Why? Because is not a standardization issue, rather it is a
technical issue. You cannot rise the initial CWND and expect a fair behavior.
This was discussed several times and is documented in several documents and
RFCs.

RFC 5681 Section 3.1. Google employees should start with Section 3. This topic
pop's of every two months in netdev and until now I _never_ read a
consolidated contribution.

Partial local issues can already be "fixed" via route specific ip options -
see initcwnd.

HGN






