Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab2HaJfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:35:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39653 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab2HaJfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:35:37 -0400
Message-ID: <50408587.5030603@gmail.com>
Date: Fri, 31 Aug 2012 11:36:07 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120826 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v3 2/2] virtio-ring: Allocate indirect buffers from cache
 when possible
References: <1346325718-11151-1-git-send-email-levinsasha928@gmail.com> <1346325718-11151-2-git-send-email-levinsasha928@gmail.com> <20120830133820.GC21132@redhat.com>
In-Reply-To: <20120830133820.GC21132@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2012 03:38 PM, Michael S. Tsirkin wrote:
>> +static unsigned int indirect_alloc_thresh = 16;
> Why 16?  Please make is MAX_SG + 1 this makes some sense.

Wouldn't MAX_SG mean we always allocate from the cache? Isn't the memory waste
too big in this case?

