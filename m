Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab0DAMbC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 08:31:02 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:61635 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754468Ab0DAMa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 08:30:58 -0400
From: Frans Pop <elendil@planet.nl>
To: Paulo Marques <pmarques@grupopie.com>
Subject: Re: Performance disparity, problem found
Date: Thu, 1 Apr 2010 14:30:55 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <4BB483E1.9050203@grupopie.com>
In-reply-To: <4BB483E1.9050203@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004011430.56503.elendil@planet.nl>
X-OriginalArrivalTime: 01 Apr 2010 12:30:57.0019 (UTC) FILETIME=[2DAEFCB0:01CAD197]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paulo Marques wrote:
> Now the problem is that /proc/cpuinfo is read only. Would it be possible
> to make /proc/cpuinfo writable so that I could do:
> 
> echo -n "model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @
> 2.40GHz" > /proc/cpuinfo
> 
> in the first machine and get a performance similar to the second machine?

Good catch! 'chmod +w /proc/cpuinfo' should do the trick.

Cheers,
FJP
