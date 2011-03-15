Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab1COCbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 22:31:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53716 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1COCbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 22:31:12 -0400
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=LVe1Hbu2v80A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=C3Vb3aNdgF9WuPIj8HgA:9 a=uxSiT6090-pzFZCPE2kA:7 a=9jndyH3-Q43kr_XIrJW1WyyXcQIA:4 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] ftrace: add 'version' special file for ring buffer
 format
From: Steven Rostedt <rostedt@goodmis.org>
To: Slava Pestov <slavapestov@google.com>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com, dhsharp@google.com
In-Reply-To: <1300142528-4918-1-git-send-email-slavapestov@google.com>
References: <1300142528-4918-1-git-send-email-slavapestov@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 14 Mar 2011 22:31:08 -0400
Message-ID: <1300156268.9910.242.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-14 at 15:42 -0700, Slava Pestov wrote:
> The intention here is that if the ftrace ring buffer format changes
> in the future like it did in the past with ktrace, we can increment
> the version number and update clients appropriately.

I purposely avoided "versions", and instead use the
tracing/events/header_page and .../header_event to describe how the ring
buffer format is laid out. If the format changes, then so should those
files.

-- Steve

> 
> Tested: Verified that special file contains correct content
> 
> This patch is against 2.6.38-rc8 but should apply to any version
> from at least 2.6.34 onwards.
> 
> Signed-Off-By: Slava Pestov <slavapestov@google.com>


