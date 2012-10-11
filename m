Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab2JKUPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:15:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab2JKUPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:15:09 -0400
Message-ID: <507728C6.9080407@suse.cz>
Date: Thu, 11 Oct 2012 22:15:02 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Nicolas Palix <nicolas.palix@imag.fr>
Cc: Julia Lawall <julia.lawall@lip6.fr>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Coccicheck: Add the rep+ctxt mode
References: <CAAxaTiOsaHOR4cbwcq=xOn-sWxB6PdB4x_UgYf2rUsPQM=WwWA@mail.gmail.com> <20121011131509.GB16465@sepie.suse.cz> <CAAxaTiOYpDZTeWbL2UsL-8FJb4rU4RoZaH-gFScU=khY4+44XQ@mail.gmail.com>
In-Reply-To: <CAAxaTiOYpDZTeWbL2UsL-8FJb4rU4RoZaH-gFScU=khY4+44XQ@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 11.10.2012 15:46, Nicolas Palix napsal(a):
> Hi,
> 
> On Thu, Oct 11, 2012 at 3:34 PM, Michal Marek <mmarek@suse.cz> wrote:
>> On Thu, Sep 20, 2012 at 10:30:46PM +0200, Nicolas Palix wrote:
>>> This adds a 'rep+ctxt' mode which prints the warning
>>> message followed by the context.
>>>
>>> Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>
>>> ---
>>>  scripts/coccicheck | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/scripts/coccicheck b/scripts/coccicheck
>>> index 823e972..eb43e40 100755
>>> --- a/scripts/coccicheck
>>> +++ b/scripts/coccicheck
>>> @@ -95,6 +95,9 @@ coccinelle () {
>>>       $SPATCH -D report  $FLAGS -sp_file $COCCI $OPT $OPTIONS -no_show_diff || \
>>>       $SPATCH -D context $FLAGS -sp_file $COCCI $OPT $OPTIONS               || \
>>>       $SPATCH -D org     $FLAGS -sp_file $COCCI $OPT $OPTIONS
>>> -no_show_diff || exit 1
>>
>> Your mailer broke this line into two, please try to avoid this next
>> time. Also, please CC lkml when submitting patches. I applied the patch
>> to kbuild.git#misc now.
> 
> Ooops.. Sorry. I didn't notice.
> 
> The patches are publish on github in my coccicheck branch.
> https://github.com/npalix/linux/commits/coccicheck
> 
> Do you prefer a pull request next time to avoid such things ?

Yes, if you base the branch on some tagged release, preferably the
latest -rc1.

Michal
