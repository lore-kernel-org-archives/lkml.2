Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab1HWGd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 02:33:56 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:37499 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab1HWGdu convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:12:1>);
	Tue, 23 Aug 2011 02:33:50 -0400
Message-Id: <4E5365E80200007800052AD2@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 23 Aug 2011 07:33:44 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Dan Magenheimer" <dan.magenheimer@oracle.com>
Cc: <hannes@cmpxchg.org>, <jackdachef@gmail.com>, <hughd@google.com>,
        <jeremy@goop.org>, <npiggin@kernel.dk>, <linux-mm@kvack.org>,
        <akpm@linux-foundation.org>, <sjenning@linux.vnet.ibm.com>,
        "Chris Mason" <chris.mason@oracle.com>,
        "Konrad Wilk" <konrad.wilk@oracle.com>,
        "Kurt Hackel" <kurt.hackel@oracle.com>, <riel@redhat.com>,
        <ngupta@vflare.org>, <linux-kernel@vger.kernel.org>, <matthew@wil.cx>
Subject: RE: Subject: [PATCH V6 1/4] mm: frontswap: swap data structure
	 changes
References: <20110808204555.GA15850@ca-server1.us.oracle.com>
 <4E414320020000780005057E@nat28.tlf.novell.com><4E414320020000780005057E@nat28.tlf.novell.com>
 <ce8cba73-ec3c-42ae-849a-11db1df8ffa3@default
 4E4179D90200007800050676@nat28.tlf.novell.com><4E4179D90200007800050676@nat28.tlf.novell.com>
 <cf3e6497-c77f-47eb-a35e-360ea68ade85@default>
In-Reply-To: <cf3e6497-c77f-47eb-a35e-360ea68ade85@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.08.11 at 19:08, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> With two extra static inlines in frontswap.h (frontswap_map_get()
> and frontswap_map_set(), I've managed to both avoid the extra swap struct
> members for frontswap_map and frontswap_pages when CONFIG_FRONTSWAP is
> disabled AND avoid the #ifdef CONFIG_FRONTSWAP clutter in swapfile.h.
> 
> I'll post a V7 soon... let me know what you think!

Sounds promising - looking forward to seeing it.

Jan

