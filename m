Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab2H3Kdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 06:33:39 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44003 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2H3Kdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 06:33:38 -0400
Message-ID: <503F419F.5040800@gmail.com>
Date: Thu, 30 Aug 2012 12:34:07 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120826 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] virtio-ring: Allocate indirect buffers from cache
 when possible
References: <1346159043-16446-1-git-send-email-levinsasha928@gmail.com> <1346159043-16446-2-git-send-email-levinsasha928@gmail.com> <20120828132032.GB2039@redhat.com> <503CC904.3050207@gmail.com> <20120829110748.GB5970@redhat.com> <503E2F27.5060904@gmail.com> <20120829151445.GC7407@redhat.com>
In-Reply-To: <20120829151445.GC7407@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2012 05:14 PM, Michael S. Tsirkin wrote:
>> > Note that these are simple tests with netperf listening on one end and a simple
>> > 'netperf -H [host]' within the guest. If there are other tests which may be
>> > interesting please let me know.
> Checking that host CPU utilization did not jump would be nice.
> E.g. measure BW/host CPU.

Tested it now, no change in CPU between the original, patch 1 and patch 2.


Thanks,
Sasha
