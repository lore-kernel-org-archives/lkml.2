Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab1KCKa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 06:30:28 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:51769 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752652Ab1KCKaV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 06:30:21 -0400
X-AuditID: 12074422-b7ff56d00000092f-10-4eb26d3b85aa
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=windows-1252
From: Theodore Tso <tytso@MIT.EDU>
X-Priority: 3
In-Reply-To: <2baa4c1a-1fe0-4395-a428-f30703e8c435@default>
Date: Thu, 3 Nov 2011 06:30:07 -0400
Cc: Theodore Tso <tytso@MIT.EDU>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Pekka Enberg <penberg@kernel.org>, Cyclonus J <cyclonusj@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        Chris Mason <chris.mason@oracle.com>, JBeulich@novell.com,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <86F488BC-2F99-4397-9467-A52AE1511FE0@mit.edu>
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default> <75efb251-7a5e-4aca-91e2-f85627090363@default> <20111027215243.GA31644@infradead.org> <1319785956.3235.7.camel@lappy> <CAOzbF4fnD=CGR-nizZoBxmFSuAjFC3uAHf3wDj5RLneJvJhrOQ@mail.gmail.comCAOJsxLGOTw7rtFnqeHvzFxifA0QgPVDHZzrEo=-uB2Gkrvp=JQ@mail.gmail.com> <552d2067-474d-4aef-a9a4-89e5fd8ef84f@default> <20111031181651.GF3466@redhat.com> <1320142590.7701.64.camel@dabdike> <49255b17-02bb-4a4a-b85a-cd5a879beb98@default 1320221686.3091.40.camel@dabdike> <2baa4c1a-1fe0-4395-a428-f30703e8c435@default>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
X-Mailer: Apple Mail (2.1251.1)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se2xLYRjG8537mh2Obuwzl8VxSyabYeTLDMP+OJEotkTEdWd6rKWt5ZwW
	E5cFIRYbmUboNuY2sk2q3YKSdVNJMSJsLrOwUCqxDTFBbIKe1i7/PV9+7/s8z5e8DK4to+IZ
	o8UqyRbRxFMaQkvPn5SUbnbrUp6/xVCl8yKNyp21FCpu/kih902HAGr848fRry4XheofLUAP
	jp3DkOsog5p6gxQKnA6QqOp8EKDgkXcAtd4sp1BH7V8SXT3goNHBb39IdPCCC0M+bzWNAiWf
	6IxYweN4TQuVbptQ96QGE06UNlNC3eVEwV19mBLcPaW0cO9kHyG88dURwvmS46Rw9+Fi4Wuw
	nRC+eJ9RgqenjhS+uccvH75ak66XTMZtkjx9fo7GcN/vofOvaXb4K4rpQlDNFIEoBnKpsL7z
	Gh7Ro+DjDidVBDSMlvMCaH/Q+//hBNBb9oNWp7RcMwbvlhhUHcPNga3+bkLVLDcL1rZ/Dmuc
	S4Y3XvSSqqY4Hr7qaSQiCSw8eSgY1lHcXFjf/TGsCW4SbCxqx9QwnPtAwaf2S1TEaBqsOtuF
	RwLS4Bd7GxlpVEPAfcX2MIjlUuCT6wEykpAAD3x/RR0DWseQUo4hpRxDfCsBXg3G6c07k8yi
	0aRIG5OUjaLFIslJs5PNRmuypLe5QfgGMvkb4Ndt3gc4BvDRrCi7dFpS3KYUmH1gNIPxI9lF
	m9067bDcrfoCg6gYNsg2k6T4AGRwPpYdvSTEWL1YsFOSt/ajMQzBx7EaT4ZOy+WJVmmLJOVL
	cj8dyzA8ZM+YQosjZClP2rHJaLIOYoyJUs2jQ+Yd6gyr5ItmxZgX4c1gQnwce1MFnAoMNsvA
	bv9Nd4K40Fdi2BfqVHTo4ge2O0PGWMj4VItTNbaKgyi+EOxZzJev9GXpplS0rm770Jp2yaUz
	7FpvmVz+vbJLb0v4lGffvStjonNvdPbUtn1LTyy4mpntXzZsxbzEhi10X+7kl3N/nsos/F1w
	fPvnlJlrF45Ylran4pZuf7rGS4981GYPGno8OfU1q/SB1Gersq607H/TXZSdcvnO7pZ1a/42
	cKl9MTyhGMQZibisiP8Aaxfbha4DAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 2, 2011, at 4:08 PM, Dan Magenheimer wrote:

> By "infinite" I am glibly describing any environment where the
> data centre administrator positively knows the maximum working
> set of every machine (physical or virtual) and can ensure in
> advance that the physical RAM always exceeds that maximum
> working set.  As you say, these machines need not be configured
> with a swap device as they, by definition, will never swap.
> 
> The point of tmem is to use RAM more efficiently by taking
> advantage of all the unused RAM when the current working set
> size is less than the maximum working set size.  This is very
> common in many data centers too, especially virtualized.

That doesn't match with my experience, especially with "cloud" deployments, where in order to make the business plans work, the machines tend to be memory constrained, since you want to pack a large number of jobs/VM's onto a single machine, and high density memory is expensive and/or you are DIMM slot constrained.   Of course, if you are running multiple Java runtimes in each guest OS (i.e., an J2EE server, and another Java VM for management, and yet another Java VM for the backup manager, etc. --- really, I've seen cloud architectures that work that way), things get worst even faster….

-- Ted

