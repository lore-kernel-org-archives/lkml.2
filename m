Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab2AII3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 03:29:46 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:21045 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab2AII3p convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 9 Jan 2012 03:29:45 -0500
Message-Id: <4F0AB384020000780006B1C2@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 09 Jan 2012 08:29:40 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <Valdis.Kletnieks@vt.edu>
Cc: <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: x86-64: memset()/memcpy() not fully standards compliant
References: <4F05BBFE020000780006A983@nat28.tlf.novell.com>Your message of
 "Thu, 05 Jan 2012 14:04:30 GMT."
 <4F05BBFE020000780006A983@nat28.tlf.novell.com>
 <73464.1325882419@turing-police.cc.vt.edu>
In-Reply-To: <73464.1325882419@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.01.12 at 21:40, <Valdis.Kletnieks@vt.edu> wrote:
> On Thu, 05 Jan 2012 14:04:30 GMT, Jan Beulich said:
>> Forever these two functions have been limited to deal with at most 4G
>> at a time. While I cannot point out an in-tree user that would require
>> larger sizes, it is now the second time that within our Xen kernel we got
>> bitten by that limitation.
> 
> Wow.  Second time?  What the heck is the Xen kernel *doing* that it's
> trying to do over 4G in a single memset/memcpy?

Please see my other reply to Andi for what data structures are
affected here (and starting at what total memory sizes).

Jan

