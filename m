Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab2DJSoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 14:44:01 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60480 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758562Ab2DJSns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 14:43:48 -0400
To: Junio C Hamano <gitster@pobox.com>
Cc: git@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git 1.7.10
References: <7v1uo01ta1.fsf@alter.siamese.dyndns.org>
From: Jakub Narebski <jnareb@gmail.com>
Date: Tue, 10 Apr 2012 11:43:46 -0700 (PDT)
In-Reply-To: <7v1uo01ta1.fsf@alter.siamese.dyndns.org>
Message-ID: <m3398bbf7y.fsf@localhost.localdomain>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano <gitster@pobox.com> writes:

> Git v1.7.10 Release Notes
> =========================
> 
> Compatibility Notes
> -------------------
[...]
>  * The "--binary/-b" options to "git am" have been a no-op for quite a
>    while and were deprecated in mid 2008 (v1.6.0).  When you give these
>    options to "git am", it will now warn and ask you not to use them.
[...]
> Updates since v1.7.9
> --------------------
[...]
>  * "git am" learned to pass "-b" option to underlying "git mailinfo", so
>    that a bracketed string other than "PATCH" at the beginning can be kept.

So how it is in 1.7.10?  Is "git am -b ..." a no-op, now showing
deprecation notice, or does it pass "-b" to "git mailinfo" to limit
stripping of bracketed strings to those containing the word "PATCH"?

-- 
Jakub Narebski

