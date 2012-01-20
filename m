Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab2ATUPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 15:15:17 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:33650 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250Ab2ATUPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 15:15:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=rBE2pMnJVFGdgQV4hYm6LyzI+ZuOcOwf
	kAiqctWxoyEtcVCjVSADOusC6V0noDStEolRON4cyRuR7RXwZVTAFCM1SDhmDfI+
	A60+vuBka4g8B216DEFTpN9fITM1x3zCyWi1VDPJJZyL8VuPyR6rD/ZiChxuStP+
	JgrZCmt849s=
From: Junio C Hamano <gitster@pobox.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-next@vger.kernel.org
Subject: Re: Linux 3.3-1 out - merge window closed
References: <CA+55aFwWEhobGDzkuRoXaS37y3tMU41ExhiR+vCa68cUNRehKg@mail.gmail.com>
 <20120120151452.2fe57bb87218f575e8909caf@canb.auug.org.au>
Date: Fri, 20 Jan 2012 12:15:12 -0800
In-Reply-To: <20120120151452.2fe57bb87218f575e8909caf@canb.auug.org.au>
 (Stephen Rothwell's message of "Fri, 20 Jan 2012 15:14:52 +1100")
Message-ID: <7vk44mdtbj.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 766D64E8-43A3-11E1-A39C-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> On Thu, 19 Jan 2012 15:58:28 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>> (Stats for those that like them: 20% arch updates (arm, power, mips,
>> x86), 60% drivers (networking - wireless in particular, staging,
>> media, dri, sound, misc - including getting rid of 'struct sysdev'),
>> and 20% random stuff: filesystems, networking, perf etc)
>
> More stats for the bored:
>
> (I don't count merge commits below and everything is relative to v3.2)

Even more stats for the really bored:

(I count only merge commits below and everything is relative to v3.2)

There are 171 merges by Linus, merging 174 side branches (there were two
Octopus merges, one merging two and the other merging three topics), 35
among which are pulling signed tags (20%).

No lieutenant pulled signed tags from his or her contributors.
