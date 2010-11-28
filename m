Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab0K1PN1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 10:13:27 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47519 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab0K1PN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 10:13:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=l7YZgTxWM+F84oWzp6JCbq2Dn3swa1u60kOCOBIf5G1F5/kLDigtcnOwqPWI5Y0EQf
         ytHcCjO/oQ04mSj9HpbAlVWt0Zc96r6elySokCBw9hvkdF7dF7op+WovcvUMdJpofMUO
         g8CUcDDoei5GpfQ0BMEbmYaWxKqPTj6uLdDdo=
MIME-Version: 1.0
In-Reply-To: <7b50614882592047dfd96f6ca2bb2d0baa8f5367.1290956059.git.minchan.kim@gmail.com>
References: <7b50614882592047dfd96f6ca2bb2d0baa8f5367.1290956059.git.minchan.kim@gmail.com>
Date: Mon, 29 Nov 2010 00:13:24 +0900
Message-ID: <AANLkTikW+WG09KetDPG9DgT5CRBkm1tqQ+tUTHjLu4N6@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] deactivate invalidated pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is add-on patch of mmotm-11-23.
Please, read original patch and thread.

http://marc.info/?l=linux-kernel&m=129034986927826&w=3

-- 
Kind regards,
Minchan Kim
