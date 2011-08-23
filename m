Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1HWL5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 07:57:55 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:39458 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab1HWL5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 07:57:51 -0400
Message-ID: <4E5395B9.9010005@landley.net>
Date: Tue, 23 Aug 2011 06:57:45 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Greg Ungerer <gerg@snapgear.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>, gerg@uclinux.org
Subject: Re: m68k with mmu doesn't compile after 66d857b08b8c3ed
References: <4E5008A1.8070105@landley.net> <CAMuHMdWfpZdwqtPgQKJHYVWRLKMXOeaMWV-mTBQxpE12XNTg_g@mail.gmail.com> <4E51CF9A.7060407@snapgear.com>
In-Reply-To: <4E51CF9A.7060407@snapgear.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2011 10:40 PM, Greg Ungerer wrote:
>> JFYI, it builds fine for all "actual m68ks" (with MMU) I'm interested in.
>> And I guess Greg will say the same for Coldfire and "actual m68ks"
>> without
>> MMU...
> 
> Yes :-)
> And from time to time I build all the defconfigs (so both MMU and
> non-MMU) in arch/m68k/configs/. I thought they all worked on 3.0
> if using an appropriate tool chain.

Sorry, building fine now.  As I replied earlier, my .config got
truncated in the move from 2.6.39 to 3.0.  My bad.

Rob
