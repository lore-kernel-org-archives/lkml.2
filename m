Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab2KKPQN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 10:16:13 -0500
Received: from catholic.ebb.org ([67.207.139.67]:47236 "EHLO catholic.ebb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab2KKPQK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 10:16:10 -0500
From: "Bradley M. Kuhn" <bkuhn@sfconservancy.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andy Grover <agrover@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marc Fleischmann <mwf@risingtidesystems.com>,
        Nicholas Bellinger <nab@risingtidesystems.com>
Subject: Re: scsi target, likely GPL violation
In-Reply-To: <20121111130553.GA30943@thunk.org> (Theodore Ts'o's message of
	"Sun, 11 Nov 2012 08:05:53 -0500")
Organization: Software Freedom Conservancy
References: <509A915B.30105@redhat.com> <1352626456.6524.46.camel@dabdike>
	<20121111130553.GA30943@thunk.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Date: Sun, 11 Nov 2012 10:15:02 -0500
Message-ID: <87390gxjbd.fsf@ebb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Nov 11, 2012 at 09:34:16AM +0000, James Bottomley wrote:
>> Anybody who does enforcement will tell you that you begin with first
>> hand proof of a violation.  That means obtain the product and make
>> sure it's been modified and that a request for corresponding source
>> fails.

I agree with James that the text quoted above is generally good advice.
However, sometimes, it's very difficult to follow this advice.  In such
cases, it's worth raising the issue directly with the company to learn
the facts.  The discussion thread here indicates there's a very good
chance that this situation was one of the times when such was necessary.
Thus, Andy's actions seem pretty reasonable to me given the facts that
seemed to be before him when he wrote his first email earlier this week.

Theodore Ts'o wrote at 08:05 (EST):
> this is a generalized statement and not one where I have attempted to
> apply the facts to the law --- that requires the expertise of a
> lawyer, and please let's not play lawyer on LKML

I agree fully with that.  IANAL either. :) I'd add, though, that lawyers
aren't magicians -- they simply have an area of expertise and it's worth
seeking a copyright law specialist in matters related to copyright.

But, such lawyers don't necessarily know better how the GPL works simply
because they passed a bar exam; I'm sure no bar exam that has questions
about the GPL.  For example, many copyright law experts understand how
copyright law works with regard to music but are lost when it comes to
applying it to software.  Also, lawyers disagree, and will often just
take the position their client wants them to take even if it's asinine
and unsupported by the law.  I've seen it happen many times.

> [I]t *is* possible for the copyright owner to license the code under
> more than once license.
...
> The bottom line is that copyright licensing can get *complicated*

I think the second sentence I've quoted above is the most salient.
While Ted's right that it *is* theoretically possible for a copyright
holder to release code under more than one license, that copyright
holder may however be confined to a single license choice due to the
fact that his/her work is derivative of another work.  The detailed
facts of a given situation, plus the license text in GPLv2§2¶2-3 and
GPLv2§7, all become very important in such situations.  In short, the
details always matter in such situations, and it's IMO impossible to
generalize beyond that.

> and so before you start flinging about accusations, one would be wise
> to be 100% sure of the facts.

Andy's initial email ended with the request: "Please explain."  Thus,
Andy's email seemed designed to seek facts, which I think is a
reasonable and good thing to do here.  Meanwhile, the facts *still*
aren't clear here yet.

James wrote:
>> [I'd like to see] a genuine public apology for the libel...
>> Because any further discussion of unsubstantiated allegations of this
>> nature exposes us all to jeopardy of legal sanction.

That's a gross overstatement.  I've seen nothing on this thread
that IMO puts anyone on the hook for libel or legal sanctions.  Can you
show us the statue that you believe was violated here?
-- 
Bradley M. Kuhn, Executive Director, Software Freedom Conservancy
