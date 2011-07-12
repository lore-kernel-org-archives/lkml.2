Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab1GLUtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 16:49:33 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56800 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab1GLUtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 16:49:32 -0400
MIME-Version: 1.0
In-Reply-To: <4E1CABBD.60901@udo.edu>
References: <CACqU3MXvHR0v4Hgn5UMwDtzaX5nWqmKEneN_s7r4PuEGzifauw@mail.gmail.com>
	<1310282825-14509-1-git-send-email-lacombar@gmail.com>
	<1310282825-14509-2-git-send-email-lacombar@gmail.com>
	<CAMT+=WY84jaattF+9zYK7oiJLmn8_oGLB-mnGbOpK_4Rt0vRZg@mail.gmail.com>
	<4E1AB992.3040309@udo.edu>
	<CAMT+=WZV4TGfXY0=BjYtNVRDuWw6r-facK=q2S6HVOUTB3KWEg@mail.gmail.com>
	<4E1CABBD.60901@udo.edu>
Date: Tue, 12 Jul 2011 16:49:31 -0400
Message-ID: <CACqU3MV0MCxa8Kb9wzk-_obe=KssHGYbvc1Oa4uxoUeHiksfag@mail.gmail.com>
Subject: Re: [PATCH 2/2] kconfig/nconf: prevent segfault on empty menu
From: Arnaud Lacombe <lacombar@gmail.com>
To: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Cc: Nir Tzachar <nir.tzachar@gmail.com>, linux-kbuild@vger.kernel.org,
        mmarek@suse.cz, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 12, 2011 at 4:17 PM, Andrej Gelenberg
<andrej.gelenberg@udo.edu> wrote:
> Hi,
>
> here is one more patch, which make empty title instead of "(null)".
>
No. You are breaking front-ends which either properly use the API and
make use menu_has_prompt() before getting the prompt with
menu_get_prompt(), or test for NULL pointer and act accordingly. Btw,
by doing this, you potentially breaking nconf too, and there is rarely
any need to modify the back-end to fix display issue in the front-end.

 - Arnaud

ps: could you please send inlined patched, that a real pain to review. thanks.

> Regards,
> Andrej Gelenberg
>
> On 07/11/2011 11:50 AM, Nir Tzachar wrote:
>> On Mon, Jul 11, 2011 at 11:51 AM, Andrej Gelenberg
>> <andrej.gelenberg@udo.edu> wrote:
>>> Hello,
>>>
>>> it show already "There is no help available for this option." message on
>>> F2. Only caption could be better as just "(null)". Besides ignore the
>>> key is much better as segfault.
>>
>> I agree. Then just add a proper caption and thats it.
>>
>> Cheers.
>>
>>> Regards
>>> Andrej Gelenberg
>
