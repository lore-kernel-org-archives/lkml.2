Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab0CXVai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:30:38 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:57863 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753741Ab0CXVag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:30:36 -0400
From: Frans Pop <elendil@planet.nl>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/09] net: remove trailing spaces in messages
Date: Wed, 24 Mar 2010 22:30:31 +0100
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       per.liden@ericsson.com, jon.maloy@ericsson.com,
       allan.stephens@windriver.com, samuel@sortiz.org,
       benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       e1000-devel@lists.sourceforge.net
References: <201003241840.18701.elendil@planet.nl> <20100324.141158.43422101.davem@davemloft.net>
In-Reply-To: <20100324.141158.43422101.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003242230.34217.elendil@planet.nl>
X-OriginalArrivalTime: 24 Mar 2010 21:30:34.0335 (UTC) FILETIME=[3CC356F0:01CACB99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 March 2010, David Miller wrote:
> All applied, but I have to make some fixups.
>
> For example, GIT warns about trailing whitespace on any lines that you
> touched so I had to fix those up before putting them into the tree.

I did wonder about fixing that or not. But as the surrounding code also has 
tons of trailing whitespace, I chose to leave things consistently messy.

I'll remove at least trailing whitespace next time.

Thanks David.
