Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab2DYW3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 18:29:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:15231 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110Ab2DYW3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 18:29:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="136786436"
Message-ID: <4F987ACB.8050604@linux.intel.com>
Date: Wed, 25 Apr 2012 15:29:31 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Peter Teoh <htmldeveloper@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-mm@kvack.org
Subject: Re: [BUG]memblock: fix overflow of array index
References: <CAHnt0GXW-pyOUuBLB1n6qBP4WNGpET9er_HbJ29s5j5DE1xAdA@mail.gmail.com> <20120425222819.GF8989@google.com>
In-Reply-To: <20120425222819.GF8989@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 03:28 PM, Tejun Heo wrote:
> 
> All indexes in memblock are integers.  Changing that particular one to
> unsigned int doesn't fix anything.  I think it just makes things more
> confusing.  If there ever are cases w/ more then 2G memblocks, we're
> going for 64bit not unsigned.
> 

I would expect there to be plenty of memblocks larger than 2G?

	-hpa


