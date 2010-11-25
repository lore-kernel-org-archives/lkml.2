Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab0KYOW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:22:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:39852 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab0KYOW6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:22:58 -0500
Subject: Re: [RFC PATCHv3] perf tools: add event grouping capability to
 "perf stat"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Julia Lawall <julia@diku.dk>,
        Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt@console-pimps.org>
In-Reply-To: <AANLkTin0jv_ka9Bw0mZCeuxTWZfdLOseYdza_3e9vMi+@mail.gmail.com>
References: <1290650053-3486-1-git-send-email-cjashfor@linux.vnet.ibm.com>
	 <1290666760.2072.539.camel@laptop>
	 <AANLkTinTNAwMCe_zu1snG1U5hSRafdBHQdzAr4e9nuWO@mail.gmail.com>
	 <1290693720.2145.34.camel@laptop>
	 <AANLkTinyL2eEfWoLoZqU-CFwC6Z3hGd0=9HgBhC_+Uef@mail.gmail.com>
	 <1290694348.2145.37.camel@laptop>
	 <AANLkTin0jv_ka9Bw0mZCeuxTWZfdLOseYdza_3e9vMi+@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 25 Nov 2010 15:22:59 +0100
Message-ID: <1290694979.2145.38.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-25 at 15:18 +0100, Stephane Eranian wrote:
> The other thing I saw, is that perf report assumes that sample_type is the
> same for all events, otherwise it dies. 

Yeah, event parsing in general needs some TLC..
