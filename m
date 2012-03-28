Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab2C1MuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:50:10 -0400
Received: from plane.gmane.org ([80.91.229.3]:33588 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab2C1MuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:50:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Nikos Chantziaras <realnc@gmail.com>
Subject: Re: [ANNOUNCE] BFS CPU scheduler version 0.420 AKA "Smoking" for
 linux kernel 3.3.0
Date: Wed, 28 Mar 2012 15:39:22 +0300
Organization: Lucas Barks
Message-ID: <jkv0q5$kgu$1@dough.gmane.org>
References: <CABqErrHS6C6RVMKChaPGACoaWoXCKf+6dS5KFrWG04+DnZO6Dw@mail.gmail.com> <201203240553.32526.gene.heskett@gmail.com> <57375.1332641134@turing-police.cc.vt.edu> <20120328051243.GA2138@fancy-poultry.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: athedsl-354751.home.otenet.gr
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120325 Thunderbird/11.0
In-Reply-To: <20120328051243.GA2138@fancy-poultry.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/03/12 08:12, Heinz Diehl wrote:
> On 25.03.2012, Valdis.Kletnieks@vt.edu wrote:
>
>> I'va always wondered what people are using to measure interactivity. Do we have
>> some hard numbers from scheduler traces, or is it a "feels faster"?
>
> I guess it's a "feels faster", because it's the only thing that
> counts. Given that there is strong evidence that scheduler A is
> "faster, more interactive", whatever... than scheduler B, but a
> controlled trial shows a significantly better "feels faster"
> experience using scheduler B, I'm quite shure that people would choose
> scheduler B over A, and that's quite ok. It does what they expect it
> to do, despite evidence which documents the opposite.

CFS: ALSA XRUNs in JACK.
BFS: much less ALSA XRUNs in JACK

