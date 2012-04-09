Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab2DIQjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 12:39:40 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:38116 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2DIQjj convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 9 Apr 2012 12:39:39 -0400
Message-Id: <4F831ED7020000780008228C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 09 Apr 2012 17:39:35 +0100
From: "Jan Beulich" <jbeulich@suse.com>
To: <konrad.wilk@oracle.com>
Cc: <david.vrabel@citrix.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 6/7] xen/setup: Make dom0_mem=XGB
 behavior be similar to classic Xen kernels.
References: <1333139850-28456-1-git-send-email-konrad.wilk@oracle.com>
 <1333139850-28456-7-git-send-email-konrad.wilk@oracle.com>
 <4F7ABBC4.4050106@citrix.com>
 <4F7AE321020000780007C456@nat28.tlf.novell.com>
 <20120406210117.GB26309@phenom.dumpdata.com>
In-Reply-To: <20120406210117.GB26309@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> 04/06/12 11:06 PM >>>
>On Tue, Apr 03, 2012 at 10:46:41AM +0100, Jan Beulich wrote:
>> >>> On 03.04.12 at 10:58, David Vrabel <david.vrabel@citrix.com> wrote:
>> > With your new behaviour it will no longer possible to specify an
>> > unlimited balloon but a limited number of initial pages.  This is
>> > behaviour that Jan said he used.
>> 
>> An unlimited balloon was never possible afaict (as that would have
>> implied setting up an "infinite" number of struct page instances at
>> boot time.
>> 
>> What I'm using is "dom0_mem=-<num>M" together with the kernel
>> option "mem=<num>G", such that max-balloon > initial alloc (usually
>> I set max-balloon to approximately the amount of memory in the
>> system, so the upper limit is "infinite" in the sense that I can't go
>> higher anyway, but it's not truly infinity).
>
>Couldn't you do the same thing with 'dom0_mem=X,max:Y'

That would be possible (albeit not exactly identical in behavior). But my
main point in the discussion was to not modify existing behavior without
actual need to (including the desire to not have to modify dozens of
command lines).

Jan

