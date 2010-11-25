Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab0KYPKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 10:10:39 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43244 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab0KYPKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 10:10:39 -0500
MIME-Version: 1.0
X-Originating-IP: [192.102.204.37]
In-Reply-To: <1290694979.2145.38.camel@laptop>
References: <1290650053-3486-1-git-send-email-cjashfor@linux.vnet.ibm.com>
	<1290666760.2072.539.camel@laptop>
	<AANLkTinTNAwMCe_zu1snG1U5hSRafdBHQdzAr4e9nuWO@mail.gmail.com>
	<1290693720.2145.34.camel@laptop>
	<AANLkTinyL2eEfWoLoZqU-CFwC6Z3hGd0=9HgBhC_+Uef@mail.gmail.com>
	<1290694348.2145.37.camel@laptop>
	<AANLkTin0jv_ka9Bw0mZCeuxTWZfdLOseYdza_3e9vMi+@mail.gmail.com>
	<1290694979.2145.38.camel@laptop>
Date: Thu, 25 Nov 2010 23:10:37 +0800
Message-ID: <AANLkTik9APXMPKJtQh8wVPexZaCzT5TjAbOBJGWn-NNL@mail.gmail.com>
Subject: Re: [RFC PATCHv3] perf tools: add event grouping capability to "perf stat"
From: Lin Ming <lin@ming.vg>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Julia Lawall <julia@diku.dk>,
        Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt@console-pimps.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 10:22 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2010-11-25 at 15:18 +0100, Stephane Eranian wrote:
>> The other thing I saw, is that perf report assumes that sample_type is the
>> same for all events, otherwise it dies.
>
> Yeah, event parsing in general needs some TLC..

Just curious, what does "TLC" stand for?
