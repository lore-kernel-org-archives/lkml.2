Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0GIRlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 13:41:53 -0400
Received: from claw.goop.org ([74.207.240.146]:58250 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab0GIRlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 13:41:52 -0400
Message-ID: <4C375F5F.5000907@goop.org>
Date: Fri, 09 Jul 2010 10:41:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: mmu notifier calls in apply_to_page_range()
References: <4C373AEC.6000502@goop.org> <20100709151211.GE13493@random.random> <4C37458B.8040408@goop.org> <20100709162255.GA5741@random.random> <4C375CC8.2030705@goop.org> <20100709173612.GF5741@random.random>
In-Reply-To: <20100709173612.GF5741@random.random>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2010 10:36 AM, Andrea Arcangeli wrote:
> I'm not opposed to removing it, I've been wondering if it made any
> sense in the first place but then there was no point not to add
> it. Just calling apply_to_page_range in non blocking context doesn't
> look so good.
>   

That's a good point.  It should be safe if the pagetable is already
fully populated; I should double-check that's true in our case.

    J

