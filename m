Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab2JCJce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 05:32:34 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab2JCJcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 05:32:33 -0400
Message-ID: <506C062D.8080608@nod.at>
Date: Wed, 03 Oct 2012 11:32:29 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: artem.bityutskiy@linux.intel.com
CC: Heinz.Egger@linutronix.de, tglx@linutronix.de,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tim.bird@am.sony.com
Subject: Re: UBI: Fastmap request for inclusion (v19)
References: <1348674710-102885-1-git-send-email-richard@nod.at>   <1349252745.2017.120.camel@sauron.fi.intel.com>   <20121003103625.0bbff63c@spider.haslach.nod.at>  <1349253885.2017.125.camel@sauron.fi.intel.com> <506BFF58.4060106@nod.at> <1349256659.2017.128.camel@sauron.fi.intel.com>
In-Reply-To: <1349256659.2017.128.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.10.2012 11:30, Artem Bityutskiy wrote:
> On Wed, 2012-10-03 at 11:03 +0200, Richard Weinberger wrote:
>> Yeah, it looks like all issues reported by aiaiai are caused by the missing goto.
>> Can you deal with the patch below or do you want me to send it using git send-email?
>
> I'll apply it. But please, re-work the error handling in that function
> separately.
>

Okay, but not now during the merge window.
Is this fine for you?

Thanks,
//richard
