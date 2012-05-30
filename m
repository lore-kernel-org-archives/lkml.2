Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2E3Pfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:35:47 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:44280 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab2E3Pfq convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Wed, 30 May 2012 11:35:46 -0400
Message-Id: <4FC65A6D0200007800086F35@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 30 May 2012 16:35:41 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <jeremy@goop.org>, "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Andre Przywara" <andre.przywara@amd.com>, <mingo@elte.hu>,
        <tglx@linutronix.de>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org#3.4+>
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
 <20120530143937.GF3207@phenom.dumpdata.com> <4FC633A7.1050406@zytor.com>
 <4FC6540E0200007800086EF7@nat28.tlf.novell.com>
 <4FC63996.9040706@zytor.com>
In-Reply-To: <4FC63996.9040706@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.05.12 at 17:15, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 05/30/2012 08:08 AM, Jan Beulich wrote:
>> 
>> Xen does trap and emulate (possibly just ignore) both instructions.
>> 
> 
> Then why the fsck is there paravirt_crap on this?

I have no clue. Jeremy, Konrad?

Jan

