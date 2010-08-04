Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab0HDEZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:25:44 -0400
Received: from maila.microsoft.com ([131.107.115.212]:7375 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab0HDEZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:25:41 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>
Subject: RE: [PATCH 3/6] staging: hv: Fixed the value of the 64bit-hole
 inside ring buffer
Thread-Topic: [PATCH 3/6] staging: hv: Fixed the value of the 64bit-hole
 inside ring buffer
Thread-Index: AcszLO9qZOv04Uv+S4i5FuiriXxrpAAQTT0AAAeYYrA=
Date: Wed, 4 Aug 2010 04:25:40 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56223FE7ADB@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <8AFC7968D54FB448A30D8F38F259C56223FD1D45@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <20100803174405.GF1455@suse.de>
In-Reply-To: <20100803174405.GF1455@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>On Tue, Aug 03, 2010 at 05:31:57PM +0000, Hank Janssen wrote:
>> From: Haiyang Zhang <haiyangz@microsoft.com>
>> 
>> Fixed the value of the 64bit-hole inside ring buffer, this caused a problem on Hyper-V 
>>when running checked Windows builds.
>
>What was the problem, and why would this fix it?  Was it a bug in this code, 
>by virtue that the code was incorrect in the client and the checked builds properly warned
>of this, or something else?

Checked builds of Windows are used internally and given to external system builders at times.
They are builds that for example that all elements in a structure follow the definition of that 
Structure. The bug this fixed was for a field that we did not fill in at all (Because we do
Not use it on the Linux side), and the checked build of windows gives errors on it internally 
to the Windows logs.

This fixes that error.

Thanks,

Hank.
 
