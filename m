Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab1KGGcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 01:32:48 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:62105 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab1KGGcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 01:32:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=OwefmqjbuhyG9tlLyQDLscFLEs+tgxno
	ltnZ/nR6dzns5ZADSZ6cgXKHLM0dfyeqq5hN5vw2dKGXs5mA3S3h1ajPuvRMhwpt
	NSIE6abuoTGNRuQ/Iqj+a87zJ6zWnsXSwAg3npBlnbQtRgkwfntxcWVTC4efwiqG
	j2yxjJFpnO8=
From: Junio C Hamano <gitster@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: EXYNOS4: Fix the merge conflict
References: <1320458934-8225-1-git-send-email-kgene.kim@samsung.com>
 <CA+55aFw8mxcwukXWe-DRYYv3tWmM6gRebgAGxAMpDLbqhqK2-Q@mail.gmail.com>
Date: Sun, 06 Nov 2011 22:32:44 -0800
In-Reply-To: <CA+55aFw8mxcwukXWe-DRYYv3tWmM6gRebgAGxAMpDLbqhqK2-Q@mail.gmail.com> (Linus
 Torvalds's message of "Sat, 5 Nov 2011 09:29:08 -0700")
Message-ID: <7v7h3c30j7.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 4DC15352-090A-11E1-BC15-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Fri, Nov 4, 2011 at 7:08 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
>> The mark of conflict should be removed.

Would the hooks/pre-commit.sample have helped? The "git diff --check" at
the last step would have caught this with modern versions of git.

