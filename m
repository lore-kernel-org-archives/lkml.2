Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249Ab1LUF2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 00:28:22 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:56595 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab1LUF2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 00:28:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=gSLWaXDsTLB+xqW4x1so/uwCwnr15K7b
	Ci+/4Lvl3LBfBtOMKl5qkZhw9jWTAy2uv4LKHuwVOgrD6EhYXRwTOx87lpXLwc6p
	sge4TcLVexLJaKdGl7lt5GLQC5QIyEv46O8JhDOF+rDUFCnues4q9PwVF9Mj/QJG
	aX3wQmAAuPE=
From: Junio C Hamano <gitster@pobox.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 bugfixes for 3.2-rc5
References: <E1RauNd-0008W1-02@tytso-glaptop.cam.corp.google.com>
 <CA+55aFw6n=WaDWRn7NqtBei1x0-w1PkH5x6r3iQSSPZvxYvDhQ@mail.gmail.com>
 <20111215190846.GA2709@thunk.org>
Date: Tue, 20 Dec 2011 21:28:15 -0800
In-Reply-To: <20111215190846.GA2709@thunk.org> (Ted Ts'o's message of "Thu,
 15 Dec 2011 14:08:46 -0500")
Message-ID: <7vd3biijdc.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 964BE0E0-2B94-11E1-9653-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted Ts'o <tytso@mit.edu> writes:

> Cool!  Does it save enough that GPG signature information can be
> verified later?  I'm a little fuzzy on what is covered by the
> signature which gets verified when you run the command "git verify-tag
> tytso-for-linus-20111214".  Better yet, does the new version of git
> have a command that will automatically verify the digital signature
> found in a merge commit?
>
> And this isn't in 1.7.8 yet, right?  I'd have to build version of git
> based on the next branch to play with this new signatury goodness?

The 'master' branch as of this week has the topic merged.


