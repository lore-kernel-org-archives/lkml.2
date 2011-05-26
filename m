Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab1EZHiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 03:38:04 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2898 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452Ab1EZHiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 03:38:02 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4DDE0343.9080008@broadcom.com>
Date: Thu, 26 May 2011 09:37:39 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
Organization: Broadcom
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17)
 Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Randy Dunlap" <randy.dunlap@oracle.com>,
        "Brett Rudley" <brudley@broadcom.com>,
        "Henry Ptasinski" <henryp@broadcom.com>,
        "Dowan Kim" <dowan@broadcom.com>,
        "Arend Van Spriel" <arend@broadcom.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] staging: Remove direct includes of printk.h
References: <cover.1306342673.git.joe@perches.com>
 <a605f8a8039f83fae3fbf61b58f846bc3c58c379.1306342673.git.joe@perches.com>
In-Reply-To: <a605f8a8039f83fae3fbf61b58f846bc3c58c379.1306342673.git.joe@perches.com>
X-WSS-ID: 61C0DBBA4NS12149033-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2011 07:02 PM, Joe Perches wrote:
> Make the uses kernel.h instead.
>
> Signed-off-by: Joe Perches<joe@perches.com>

Acked-by: Roland Vossen <rvossen@broadcom.com>

