Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab1HIOPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:15:49 -0400
Received: from claw.goop.org ([74.207.240.146]:36524 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab1HIOPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:15:49 -0400
Message-ID: <4E405F71.1070106@goop.org>
Date: Mon, 08 Aug 2011 15:13:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Christian Kujau <lists@nerdbynature.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: redefinition of typedef '__guest_handle_uint64_t'
References: <alpine.DEB.2.01.1108080146000.9183@trent.utfs.org> <20110808143723.GB7213@dumpdata.com>
In-Reply-To: <20110808143723.GB7213@dumpdata.com>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2011 07:37 AM, Konrad Rzeszutek Wilk wrote:
> On Mon, Aug 08, 2011 at 01:54:39AM -0700, Christian Kujau wrote:
>> Hi,
>>
>> when trying to compile xen/next-3.0 from Jeremy's tree, this happens:
> Ugh, just use the released 3.0 stock kernel.

Concur.  xen/next-3.0 is not up to date.

    J
