Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106Ab1GSQ2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 12:28:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33684 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1GSQ2x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 12:28:53 -0400
MIME-Version: 1.0
In-Reply-To: <4E258FAE.6040807@suse.cz>
References: <1309563076-5050-1-git-send-email-lacombar@gmail.com>
	<1309563076-5050-2-git-send-email-lacombar@gmail.com>
	<CACqU3MU1kFzn9916A8vq+jB+r=4iDmWp_kk=E+thPuojWwZA6g@mail.gmail.com>
	<4E258FAE.6040807@suse.cz>
Date: Tue, 19 Jul 2011 12:28:52 -0400
Message-ID: <CACqU3MU7BxhZBU1_8Z_bQ2yb4fPHhYrAk2mMPSNSxPMWud=RvA@mail.gmail.com>
Subject: Re: [RFC 1/4] kbuild: export MAKECMDGOALS
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 19, 2011 at 10:07 AM, Michal Marek <mmarek@suse.cz> wrote:
> On 18.7.2011 21:05, Arnaud Lacombe wrote:
>>
>> Hi,
>>
>> On Fri, Jul 1, 2011 at 7:31 PM, Arnaud Lacombe<lacombar@gmail.com>  wrote:
>>>
>>> Cc: Steven Rostedt<srostedt@redhat.com>
>>> ---
>>>  Makefile |    3 +++
>>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/Makefile b/Makefile
>>> index afb8e0d..ea517fd 100644
>>> --- a/Makefile
>>> +++ b/Makefile
>>> @@ -22,6 +22,9 @@ LC_COLLATE=C
>>>  LC_NUMERIC=C
>>>  export LC_COLLATE LC_NUMERIC
>>>
>>> +# Export make goals
>>> +export MAKECMDGOALS
>>> +
>>>  # We are using a recursive build, so we need to do a little thinking
>>>  # to get the ordering right.
>>>  #
>>
>> Michal, before I send a new version of this serie, can you tell me
>> your point of view on the export of MAKECMDGOALS (or
>> KBUILD_MAKECMDGOALS) and Kconfig to the environment ?
>
> A cleaner interface would IMO be to check the target in the makefile and
> pass a commandline option to streamline_config.pl, so that it's easier to
> run it manually.
>
thanks, I'll do the same for $(Kconfig), ie. pass it on the command line.

 - Arnaud
