Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468Ab0JSADI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 20:03:08 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54882 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab0JSADG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 20:03:06 -0400
Message-ID: <4CBCE039.2030501@kernel.org>
Date: Mon, 18 Oct 2010 17:03:05 -0700
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.7
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: More issues found on kernel.org
References: <4CBC9CC7.7050204@kernel.org> <20101018221528.GC31479@mail.oracle.com>
In-Reply-To: <20101018221528.GC31479@mail.oracle.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Mon, 18 Oct 2010 17:03:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2010 03:15 PM, Joel Becker wrote:
> On Mon, Oct 18, 2010 at 12:15:19PM -0700, J.H. wrote:
>> Not that the current discussion on IMA, and the recent problems found
>> with XFS were enough, I've started seeing, rather regularly, what I've
>> reported in bugzilla
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=20702
>>
>> It looks like a double free is happening somewhere, and the issue
>> *SEEMS* to be limited to the dynamic web boxes (bugzilla, wiki's, etc)
>> and those are the only boxes I have running drbd and ocfs2.
> 
> 	Obviously with no ocfs2 in the stack traces, it's hard to say
> anything from that perspective.  Do you have any idea what file snmpd is
> closing?

Wasn't pointing the finger at ocfs2, or drbd for that matter, was noting
that was running on the box as those are the only two boxes with it, and
those are the boxes having issues right now.  I'm at the point where I
have no idea *WHAT* was causing the problem just trying to get as much
info out there for debugging as possible.

As to what files snmpd was closing, no idea.  I'm using snmpd both for
monitoring of the boxes, but HP's utilities are using it for a pile of
things as well, including disk monitoring and such.  Could have been
just about anything unfortunately and I'm not sure there's a good way to
trap that if/when it happens again.

If I get to that state again is there anything that would be useful
(from a debugging perspective) to snag before the box falls over, I
might be able to get some sysrq requests back if anyone would find that
helpful, and might be able to poke around a bit, not sure how far I can
get before it becomes unusable yet.

- John 'Warthog9' Hawley
