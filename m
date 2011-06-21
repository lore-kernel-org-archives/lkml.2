Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab1FUKAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 06:00:31 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:40020 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab1FUKA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 06:00:28 -0400
Message-ID: <4E006BB9.90505@itwm.fraunhofer.de>
Date: Tue, 21 Jun 2011 12:00:25 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110510 Iceowl/1.0b2 Icedove/3.1.10
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 3.0-rc3 kmemleak reports
References: <itpou0$leu$1@dough.gmane.org> <20110621095733.GA10396@1n450.cable.virginmedia.net>
In-Reply-To: <20110621095733.GA10396@1n450.cable.virginmedia.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ITWM-CharSet: ISO-8859-1
X-ITWM-Scanned-By: mail2.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2011 11:57 AM, Catalin Marinas wrote:
> On Tue, Jun 21, 2011 at 11:40:15AM +0200, Bernd Schubert wrote:
>> For some reasons I build a kernel with kmemleak support and got a
>> few reports.
>
> Do you know if they appear in 2.6.39 as well?

No idea, if it is important I can build a previous kernel version (but 
please, no bisecting, I'm too busy with other things).


Cheers,
Bernd
