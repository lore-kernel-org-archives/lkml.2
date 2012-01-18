Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab2ARBHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 20:07:43 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:53287 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754212Ab2ARBHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 20:07:40 -0500
MIME-Version: 1.0
In-Reply-To: <7vehuyosaa.fsf@alter.siamese.dyndns.org>
References: <7vehuyosaa.fsf@alter.siamese.dyndns.org>
From: Andrew Ardill <andrew.ardill@gmail.com>
Date: Wed, 18 Jan 2012 12:07:18 +1100
Message-ID: <CAH5451nSMcJ50fu2qtMkw4zPpx-Kg-k-jqCcpryu+pkC8JX8rw@mail.gmail.com>
Subject: Re: Using signed tag in pull requests
To: Junio C Hamano <gitster@pobox.com>
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks pretty good Junio, though one of the lines was a bit confusing:

On 18 January 2012 09:53, Junio C Hamano <gitster@pobox.com> wrote:

> Starting from Git release v1.7.9, a contributor can add a signed tag to
> the commit at the tip of the history and ask the integrator to pull that
> signed tag. When the integrator runs `git pull`, the signed tag is
> automatically verified to assure that the history is not tampered with.
> In addition, the resulting merge commit records the content of the signed
> tag, so that other people can verify that the branch merged by the
> contributor was signed by the contributor, without fetching the signed tag

I think you mean to say 'the branch merged by the integrator was signed
by the contributor'. If you are talking about two separate contributors, or
the same contributor merging one of her own branches, the wording can
likely be improved.

> used to validate the pull request separately and keeping it in the refs
> namespace.

Overall it was easy to understand and makes the whole workflow quite clear.

Regards,
Andrew Ardill
