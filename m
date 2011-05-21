Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab1EUVht (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 17:37:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56897 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab1EUVhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 17:37:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YCHcaJsFozmE9Fpmj8hSvG+GDtOjN2rJ4tpN69xIHfAU7Fn0PAdCILWBu24Cke1qmi
         2D/mDSC+1NCaFMu/lW6ZyM8IzRU1fElo2rsJalh275L9yI5JA/ToF8syU+a7AJDjkW4N
         AmNd7PxymEEceKPVlCfhNMpk3GjyUwuACGtqA=
Message-ID: <4DD830A7.80507@openvz.org>
Date: Sun, 22 May 2011 01:37:43 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, steiner@sgi.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86, apic: apicdriver probe cleanups - V2
References: <20110521005116.136357574@sbsiddha-MOBL3.sc.intel.com>
In-Reply-To: <20110521005116.136357574@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2011 04:51 AM, Suresh Siddha wrote:
> Updated patchset for cleaning up apic probe sequence by using apicdriver
> section.
> 
> Changes from V1:
>  * split up the patch into four small patches
>  * misc cleanups, specifying section alignment, removing duplicate messages
>    (from Cyrill and Yinghai's review comments)
>  * fixed a crash on smaller x64 systems
> 

FWIW it runs fine on my Core 2 machine, setting apic driver to flat as expected.
For flat apic mode

Tested-by: Cyrill Gorcunov <gorcunov@openvz.org>

Thanks a lot Suresh!
-- 
    Cyrill
