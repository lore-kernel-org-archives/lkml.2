Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128Ab0D3Sph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:45:37 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:2295 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932922Ab0D3RQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:16:39 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: [regression,bisected] Missing boot messages with VESAFB after VT initialization
Date: Thu, 29 Apr 2010 06:25:39 +0200
User-Agent: KMail/1.9.9
Cc: x86@kernel.org, Alan Cox <alan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Ari Entlich <atrigent@ccs.neu.edu>
References: <201004171718.55867.elendil@planet.nl> <201004290614.24016.elendil@planet.nl>
In-Reply-To: <201004290614.24016.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004290625.40469.elendil@planet.nl>
X-Length: 1386
X-OriginalArrivalTime: 30 Apr 2010 17:16:36.0237 (UTC) FILETIME=[E36EDBD0:01CAE888]
X-RecipientDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 April 2010, Frans Pop wrote:
>  * commit eec9fe7d1ab4a0dfac4cb43047a7657fffd0002f
>    Author: Ari Entlich <atrigent@ccs.neu.edu>
>       tty: Add a new VT mode which is like VT_PROCESS but doesn't
>            require a VT_RELDISP
>
> The last one is probably the most likely as the issue occurs after an
> init script loops over all VTs to run 'consolechars' and/or 'charset'.

I just see this patch has already been reverted, so that can't be it.
I'm still seeing the problem with v2.6.34-rc5-270-gbc113f1.
