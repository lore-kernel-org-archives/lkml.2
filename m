Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab1K2Qh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 11:37:59 -0500
Received: from mail2.vodafone.ie ([213.233.128.44]:58566 "EHLO
	mail2.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab1K2Qh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 11:37:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqMBAN0J1U5tTdZN/2dsb2JhbAAMN6hXhRoBAQEEMgFGEAsNAQoJFg8JAwIBAgFFBg0BBwEBv0yLHgSaOYws
Message-ID: <4ED50A63.1010805@draigBrady.com>
Date: Tue, 29 Nov 2011 16:37:55 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Li Shaohua <shaohua.li@intel.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] readahead: basic support for backwards prefetching
References: <20111129130900.628549879@intel.com> <20111129131456.925952168@intel.com> <20111129153552.GP5635@quack.suse.cz>
In-Reply-To: <20111129153552.GP5635@quack.suse.cz>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 03:35 PM, Jan Kara wrote:
>   Someone already mentioned this earlier and I don't think I've seen a
> response: Do you have a realistic usecase for this? I don't think I've ever
> seen an application reading file backwards...

tac, tail -n$large, ...

cheers,
Pádraig.
