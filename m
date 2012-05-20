Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab2ETQgh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 12:36:37 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621Ab2ETQgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 12:36:36 -0400
Message-ID: <4FB91D9B.7060808@nod.at>
Date: Sun, 20 May 2012 18:36:43 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: jonas@southpole.se, linux@openrisc.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OpenRISC: Make do_signal() non-static
References: <1337426347-3557-1-git-send-email-richard@nod.at> <20120520161839.GA16706@infradead.org>
In-Reply-To: <20120520161839.GA16706@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.05.2012 18:18, schrieb Christoph Hellwig:
> On Sat, May 19, 2012 at 01:19:07PM +0200, Richard Weinberger wrote:
>> There is no need to export this function.
>
> s/non-static/static/ in the subject?
>

*grrr*, yes.

Thanks,
//richard
