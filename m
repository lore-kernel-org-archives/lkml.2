Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab2ARNeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 08:34:01 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:13625 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397Ab2ARNeA convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 18 Jan 2012 08:34:00 -0500
Message-Id: <4F16D854020000780006D757@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 18 Jan 2012 13:33:56 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <tglx@linutronix.de>, "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: fix memset() to support sizes of 4Gb and
 above
References: <4F05D992020000780006AA09@nat28.tlf.novell.com>
 <20120106110519.GA32673@elte.hu>
 <4F16AFB1020000780006D671@nat28.tlf.novell.com>
 <20120118111404.GA12152@elte.hu>
In-Reply-To: <20120118111404.GA12152@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 18.01.12 at 12:14, Ingo Molnar <mingo@elte.hu> wrote:
> Cool and thanks for looking into this. Will wait for your 
> patch(es).

With them just submitted, is there anything else that I need to do to
have the original memset() change applied? I didn't want to submit
the memcpy equivalent (and a small follow-up one) without it having
a realistic chance of going in (which I assume it won't have when the
memset() one isn't acceptable for whatever reason).

Jan

