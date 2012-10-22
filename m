Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab2JVBo0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 21:44:26 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:46002 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932763Ab2JVBoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 21:44:25 -0400
Message-ID: <5084A4F5.4030509@xenotime.net>
Date: Sun, 21 Oct 2012 18:44:21 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Cong Wang <xiyou.wangcong@gmail.com>
CC: Cruz Julian Bishop <cruzjbishop@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Quick question: Maintainers for scripts
References: <1350858942.2547.2.camel@CruzBishop-ASPIRE> <CAM_iQpVMzYufF71jKOhbKh9r=PaEgJdSZeRs_Z9fzyv4E4e+Wg@mail.gmail.com>
In-Reply-To: <CAM_iQpVMzYufF71jKOhbKh9r=PaEgJdSZeRs_Z9fzyv4E4e+Wg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2012 06:37 PM, Cong Wang wrote:

> On Mon, Oct 22, 2012 at 6:35 AM, Cruz Julian Bishop
> <cruzjbishop@gmail.com> wrote:
>> Hi everyone,
>>
>> I was just wondering - Since (last time I looked, anyway),
>> /scripts/* has no maintainer, who would I send patches to?
>>
>> Would I just send them to the mailing list, or is there a
>> sort of catch-all maintainer for things like this?
>>
> 
> linux-kbuild@vger.kernel.org


That is probably the best single answer.

An alternative is to run ./scripts/get_maintainer.pl -f $filename
on each file in scripts.  That will give you more explicit and more
correct answers.


-- 
~Randy
