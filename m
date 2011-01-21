Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab1AUWdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 17:33:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43102 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901Ab1AUWdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 17:33:53 -0500
Message-ID: <4D3A096C.7060800@zytor.com>
Date: Fri, 21 Jan 2011 14:32:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Tejun Heo <tj@kernel.org>, Pekka Enbeerg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        akpm@linux-foundation.org
Subject: Re: x86: A fast way to check capabilities of the current cpu
References: <alpine.DEB.2.00.1012151404070.21102@router.home> <20110121171133.GI2832@htj.dyndns.org> <alpine.DEB.2.00.1101211114530.15692@router.home> <20110121172836.GK2832@htj.dyndns.org> <alpine.DEB.2.00.1101211139330.15692@router.home>
In-Reply-To: <alpine.DEB.2.00.1101211139330.15692@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2011 09:46 AM, Christoph Lameter wrote:
>> Oh, you're right.  Sorry about that.  Can you please then add a
>> comment noting that the operation is x86 only?  Maybe prefix it with
>> x86_?
> 
> For a function defined in an specific include file and only used in arch
> specific code?

Yes, x86_ prefix to indicate it's an x86-specific interface, as opposed
to arch_ which is a architecture-specific component of the
implementation of a generic interface.

	-hpa
