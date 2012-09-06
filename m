Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab2IFKdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 06:33:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55085 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757783Ab2IFKdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 06:33:35 -0400
Message-ID: <50487BFA.2010105@suse.cz>
Date: Thu, 06 Sep 2012 12:33:30 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        mark.asselstine@windriver.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] kbuild rc fixes for v3.6
References: <20120903191801.GA23227@pobox.suse.cz> <CA+55aFzBsKBmVMRiJ8yuML_QVQbfa2ZqHU_fh3_wS3YhLTv9fw@mail.gmail.com> <20120906151951.8c30cb06fcb20412910006d2@canb.auug.org.au>
In-Reply-To: <20120906151951.8c30cb06fcb20412910006d2@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.9.2012 07:19, Stephen Rothwell wrote:
> On Wed, 5 Sep 2012 20:32:00 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>> On Mon, Sep 3, 2012 at 12:18 PM, Michal Marek <mmarek@suse.cz> wrote:
>>> are available in the git repository at:
>>>   git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git ..BRANCH.NOT.VERIFIED..
>>
>> There's something wrong with that repo
>>
>>  "fatal: Could not read from remote repository.
>>
>>   Please make sure you have the correct access rights
>>   and the repository exists."
>>
>> plus that BRANCH.NOT.VERIFIED thing looks bad too (and is probably related).

Oops.


> The kbuild-current tree in linux-next is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git rc-fixes
> 
> and it has those 2 commits in it.  So script update needed, I guess.

I did update my script, but the last pull request was sent from a
machine that had the old copy :).

Michal
