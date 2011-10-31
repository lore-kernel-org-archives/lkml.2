Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab1JaO1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 10:27:05 -0400
Received: from mail96.atlas.de ([194.156.172.86]:14264 "EHLO mail96.atlas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831Ab1JaO1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 10:27:04 -0400
X-Greylist: delayed 545 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Oct 2011 10:27:04 EDT
Message-ID: <4EAEAE13.50101@atlas-elektronik.com>
Date: Mon, 31 Oct 2011 15:17:55 +0100
From: =?UTF-8?B?U3RlZmFuIE7DpHdl?= <stefan.naewe@atlas-elektronik.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Junio C Hamano <gitster@pobox.com>
Cc: "git@vger.kernel.org" <git@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git 1.7.8.rc0
References: <7vfwi9rc0g.fsf@alter.siamese.dyndns.org>
In-Reply-To: <7vfwi9rc0g.fsf@alter.siamese.dyndns.org>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 31.10.2011 06:00, schrieb Junio C Hamano:
> A release candidate Git 1.7.8.rc0 is available for testing.
> 
> [...]
> 
> 
> Git v1.7.8 Release Notes (draft)
> ================================
> 
> Updates since v1.7.7
> --------------------
> 
> [...]
> 
>  * HTTP transport did not use pushurl correctly, and also did not tell
>    what host it is trying to authenticate with when asking for
>    credentials.
>    (merge deba493 jk/http-auth later to maint).

This seems to break pushing with https for me.
It never uses values from my '~/.netrc'.
I'll come up with a detailed scenario later.

 
Stefan
-- 
----------------------------------------------------------------
/dev/random says: Justice is incidental to law and order.
python -c "print '73746566616e2e6e616577654061746c61732d656c656b74726f6e696b2e636f6d'.decode('hex')"
