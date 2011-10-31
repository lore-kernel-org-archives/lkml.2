Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934579Ab1JaWVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:21:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40592 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934139Ab1JaWVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:21:03 -0400
Message-ID: <4EAF1F40.3030907@zytor.com>
Date: Mon, 31 Oct 2011 15:20:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Junio C Hamano <gitster@pobox.com>, git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike> <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com> <1320049150.8283.19.camel@dabdike> <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com> <7vy5w1ow90.fsf@alter.siamese.dyndns.org> <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
In-Reply-To: <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2011 03:18 PM, Linus Torvalds wrote:
> On Mon, Oct 31, 2011 at 11:23 AM, Junio C Hamano <gitster@pobox.com> wrote:
>>
>> It certainly lets you run "git tag --verify" after you pulled and will
>> give you assurance that you pulled the right thing from the right person,
>> but what do you plan to do to the tag from your lieutenants after you
>> fetched and verified?  I count 379 merges by you between 3.0 (2011-07-21)
>> and 3.1 (2011-10-24), which would mean you would see 4-5 tags per day on
>> average.  Will these tags be pushed out to your public history?
> 
> No, you misunderstand.
> 
> I can do that kind of "crazy manual check of a tag" today. And it's
> too painful to be useful in the long run (or even the short run - I'd
> much prefer the pgp signature in the email which is easier to check
> and more visible anyway). Fetching a tag by name and saving it as a
> tag is indeed pointless.
> 
> But what would be nice is that "git pull" would fetch the tag (based
> on name) *automatically*, and not actually create a tag in my
> repository at all. Instead, if would use the tag to check the
> signature, and - if we do this right - also use the tag contents to
> populate the merge commit message.
> 
> In other words, no actual tag would ever be left around as a turd, it
> would simply be used as an automatic communication channel between the
> "git push -s" of the submitter and my subsequent "git pull". Neither
> side would have to do anything special, and the tag would never show
> up in any relevant tree (it could even be in a totally separate
> namespace like "refs/pullmarker/<branchname>" or something).
> 

Perhaps we should introduce the notion of a "private tag" or something
along those lines?  (I guess that would still have to be possible to
push it, but not pull it by default...)

	-hpa

