Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab1HXJBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 05:01:08 -0400
Received: from server655-han.de-nserver.de ([85.158.177.45]:36009 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756603Ab1HXJBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 05:01:07 -0400
Message-ID: <4E54BDCF.9020504@profihost.ag>
Date: Wed, 24 Aug 2011 11:01:03 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Jens Axboe <jaxboe@fusionio.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: slow performance on disk/network i/o full speed after drop_caches
References: <4E5494D4.1050605@profihost.ag> <CAOJsxLEFYW0eDbXQ0Uixf-FjsxHZ_1nmnovNx1CWj=m-c-_vJw@mail.gmail.com>
In-Reply-To: <CAOJsxLEFYW0eDbXQ0Uixf-FjsxHZ_1nmnovNx1CWj=m-c-_vJw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> sync&&  echo 3>/proc/sys/vm/drop_caches&&  sleep 2&&  echo 0
>>> /proc/sys/vm/drop_caches

Another way to get it working again is to stop some processes. Could be 
mysql or apache or php fcgi doesn't matter. Just free some memory. 
Although there are already 5GB free.

Stefan
