Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab2EaP4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:56:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932616Ab2EaP4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:56:04 -0400
Date: Thu, 31 May 2012 12:55:49 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        mingo@elte.hu
Subject: Re: [BUG] perf tools: does not load global variables syms from main
 program
Message-ID: <20120531155549.GB28571@infradead.org>
References: <CABPqkBRSRZR4KwbauNTDfH19w+1sDZ3yfnihMHzQg312mWPzSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRSRZR4KwbauNTDfH19w+1sDZ3yfnihMHzQg312mWPzSQ@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, May 30, 2012 at 05:01:39PM +0200, Stephane Eranian escreveu:
> I am not too much of an expert is that area, so I am seeking advice on
> how to best
> fix this ASAP.

Can you send me your patches + test program?

- Arnaldo
