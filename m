Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab2ADAuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 19:50:04 -0500
Received: from lo.gmane.org ([80.91.229.12]:33361 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805Ab2ADAuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 19:50:01 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-1?Q?Sven_K=F6hler?= <sven.koehler@gmail.com>
Subject: Re: [PATCH 0/3] x86/microcode: support for microcode update in Xen
 dom0
Date: Wed, 04 Jan 2012 01:49:49 +0100
Message-ID: <je07nb$m1l$1@dough.gmane.org>
References: <4E95E7FE.6050302@goop.org> <20111012194543.GD14966@aftab> <20111012204048.GA22260@phenom.oracle.com> <4E960746.90805@zytor.com> <20111012214013.GD28723@aftab> <4E96198F.4030906@zytor.com> <4E962581.2000605@goop.org> <4E9628D4.1000605@zytor.com> <4E962A27.4090509@goop.org> <4E962AE6.1060505@zytor.com> <20111013070050.GA501@aftab>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 31-18-52-176-dynip.superkabel.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111116 Thunderbird/8.0
In-Reply-To: <20111013070050.GA501@aftab>
X-Enigmail-Version: 1.3.3
Cc: xen-devel@lists.xensource.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.10.2011 09:00, schrieb Borislav Petkov:
> On Wed, Oct 12, 2011 at 08:03:50PM -0400, H. Peter Anvin wrote:
>> On 10/12/2011 05:00 PM, Jeremy Fitzhardinge wrote:
>>>
>>> Presumably we'd want some way to make all possible microcode files
>>> available to the hypervisor/kernel so that there's no need to construct
>>> the bootloader config for a specific CPU vendor (or worse, CPU model).
>>> So that would need either some way of specifying multiple files, or a
>>> wrapper which can contain multiple files?
>>>
>>
>> I have been thinking a "bundle" format with a per-vendor header followed 
>> by the microcode in the appropriate format for each vendor.
> 
> Yes, makes sense. Keep it as simple as possible.

For the majority of the past 10 years, the microcode has been shipped as
one big file (at least for intel).
So have you looked at the file format of the bundles that already exist?

