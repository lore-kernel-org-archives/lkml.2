Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab1KBNUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 09:20:33 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42692 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab1KBNUc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 09:20:32 -0400
MIME-Version: 1.0
In-Reply-To: <20111102070042.GA7136@game.jcrosoft.org>
References: <1319706448-1664-1-git-send-email-nicolas.ferre@atmel.com>
 <4EAAABF6.50803@gmail.com> <20111029114905.GA22592@ponder.secretlab.ca> <20111102070042.GA7136@game.jcrosoft.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 2 Nov 2011 09:20:11 -0400
X-Google-Sender-Auth: 2T433ZEjw4ZQlmxpm-Chkjw0cXg
Message-ID: <CACxGe6vepsvk=7DK0-4O=TD3g4qKT_TGZV_iUGLEBX6XV8Y6fw@mail.gmail.com>
Subject: Re: [PATCH] dt: add empty of_alias_get_id() for non-dt builds
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Rob Herring <robherring2@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 2, 2011 at 3:00 AM, Jean-Christophe PLAGNIOL-VILLARD
<plagnioj@jcrosoft.com> wrote:
> On 13:49 Sat 29 Oct     , Grant Likely wrote:
>> On Fri, Oct 28, 2011 at 08:19:50AM -0500, Rob Herring wrote:
>> > On 10/27/2011 04:07 AM, Nicolas Ferre wrote:
>> > > Add function of_alias_get_id() reporting -ENOSYS
>> > > for non-dt builds, so that drivers migrating to dt
>> > > can save some '#ifdef CONFIG_OF'.
>> > >
>> > > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> >
>> > Acked-by: Rob Herring <rob.herring@calxeda.com>
>>
>> Merged, thanks
>>
>> Rob, for stuff like this, please do pick it up into your git tree and
>> reply saying that you've done so.  Then I know I can ignore it because
>> I'll be receiving a pull req from you in short order.
>>
>> Similarly, I reply whenever I pick up a patch, so you'll know if I've
>> already delt with it.
> this is still missing in the mainline kernel
>
> the at91 ends broken can one of you send a pull with it to Linus

The pull req will be going out soon.

g.
