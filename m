Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab2JBMkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 08:40:22 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39137 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab2JBMkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 08:40:20 -0400
MIME-Version: 1.0
In-Reply-To: <CA+MoWDqxXPiuFwmznynn8SPK20eJUgCKonq+C=s8fKvcnkb4Aw@mail.gmail.com>
References: <1349179024-5319-1-git-send-email-peter.senna@gmail.com>
	<20121002121443.GT4587@mwanda>
	<CA+MoWDqxXPiuFwmznynn8SPK20eJUgCKonq+C=s8fKvcnkb4Aw@mail.gmail.com>
Date: Tue, 2 Oct 2012 09:40:19 -0300
Message-ID: <CALF0-+W25fAD0=kLD085G+H1b-WFaARudo-hkJO_LoBTNZC-Nw@mail.gmail.com>
Subject: Re: [PATCH RFC] MAINTAINERS: Add section for subsystem shortname
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, joe@perches.com,
        gregkh@linuxfoundation.org, davem@davemloft.net, arnd@arndb.de,
        Julia.Lawall@lip6.fr, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 9:33 AM, Peter Senna Tschudin
<peter.senna@gmail.com> wrote:
> On Tue, Oct 2, 2012 at 2:14 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> On Tue, Oct 02, 2012 at 01:57:04PM +0200, Peter Senna Tschudin wrote:
>>> The shortname for a subsystem, that is primarly used when sending patches over E-mail, is not stored anywhere in the source code. Actually one need to dig git log or mailing list archives. There is no standard, and the Maintainer choose how to short name his/her subsystem. MAINTAINERS file is the right place for storing this information.
>>>
>>> U is the second letter of Subsystem.
>>>
>>> This will also enable automatic tools like scripts/get_maintainer.pl to provide the correct short name for each filename in the Kernel source tree.
>>>
>>
>> This is pretty useless without a script to parse it.  Also none of
> With or without a script, there is no default way of finding the short
> name. Changing scripts/get_maintainer.pl to do it does not seems very
> complex.
>

Perhaps you should do get_maintainer.pl changes yourself and then
use it to test on some of your patches to see what subject it produces.

Then it's easier to see if the proposal makes sense.
A new rule / standard is something hard to push and we want to have as much
facts as possible to make better decisions.

Thanks,
Ezequiel.
