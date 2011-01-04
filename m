Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab1ADImU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:42:20 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:39883 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1ADImT convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Tue, 4 Jan 2011 03:42:19 -0500
Message-Id: <4D22EB76020000780002A23D@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 04 Jan 2011 08:42:14 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix section mismatch in LAPIC initialization
References: <4D21F338020000780002A112@vpn.id2.novell.com>
 <4D22159C.6080402@zytor.com>
In-Reply-To: <4D22159C.6080402@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 03.01.11 at 19:29, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 01/03/2011 07:03 AM, Jan Beulich wrote:
>> Doing things conditionally upon spm_processor_id() being zero is
>> generally a bad idea, as this means CPU 0 cannot be offlined and
>> brought back online later again. While there may be other places where
>> this is done, I think adding more of those should be avoided so that
>> some day SMP really becomes "symmetrical".
>> 
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> The description doesn't really match the subject line...

The subject, imo, doesn't need further explanation. The description
was meant to explain why the function gets broken up rather than
just fiddling with other (called) functions' annotations. Are you
suggesting to drop the description altogether?

Jan

