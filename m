Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab0KWLmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 06:42:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:52521 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab0KWLmw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 06:42:52 -0500
Subject: Re: [PATCH] perf: add support for per-event sampling period or
 frequency in perf record
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com
In-Reply-To: <AANLkTikuhX=bFjOCL_DtaPJGTvS0TvQd6i8ayQjP=GJk@mail.gmail.com>
References: <4ceb9b74.e6edd80a.3271.fffff742@mx.google.com>
	 <1290510680.2072.390.camel@laptop>
	 <AANLkTi=cBpL8oKC-JfLVXJ20gG+M9taWvOq=vRszkuvn@mail.gmail.com>
	 <AANLkTikuhX=bFjOCL_DtaPJGTvS0TvQd6i8ayQjP=GJk@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Nov 2010 12:42:39 +0100
Message-ID: <1290512559.2072.393.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 12:33 +0100, Stephane Eranian wrote:
> 
> Forgot to say, that the reason I did it thru -c and -F was to maintain
> backward compatibility. 

Right, we could keep the existing parameters to mean default values for
those events that didn't specify anything.
