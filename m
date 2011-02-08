Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab1BHFWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 00:22:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33110 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab1BHFWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 00:22:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=k8tavCOAaob1SB+paq/rK85qRbR/l5wCZti70e2XEeAAAD4CxdubB+TqYzR1ZtqRWd
         lE+MDrr8f/0dwlJWc09nyKiwTOGn9mBeEgNvpMX7Ga9k/g2R3LY4KhJ1F37EeCGzJb7d
         uW2Aj6xAgRweKU8pHziwn4SXdZXYEPS+kC9bQ=
Message-ID: <4D50D2B0.8030106@gmail.com>
Date: Mon, 07 Feb 2011 22:20:48 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: "J.H." <warthog9@kernel.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "hpa@kernel.org" <hpa@kernel.org>, dgc@kernel.org, elder@kernel.org,
        hch@kernel.org
Subject: Re: do_raw_spin_lock using a lot of the system cpu time
References: <4D508BDC.1020309@kernel.org>
In-Reply-To: <4D508BDC.1020309@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/07/11 17:18, J.H. wrote:

> The debugging that so far is (via perf top) claims that alloc_vmap_area,
> rb_next and do_raw_spin_lock are involved in some combination, with
> do_raw_spin_lock being the item taking up 80-90% of the time that perf
> top can see.

Have you tried 'perf record -ga' to see the various paths to
_raw_spin_lock and rb_next?

David
