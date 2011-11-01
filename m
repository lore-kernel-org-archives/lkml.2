Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab1KAJxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 05:53:05 -0400
Received: from mail96.atlas.de ([194.156.172.86]:29993 "EHLO mail96.atlas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab1KAJxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:53:04 -0400
Message-ID: <4EAFC18A.1070502@atlas-elektronik.com>
Date: Tue, 01 Nov 2011 10:53:14 +0100
From: =?UTF-8?B?U3RlZmFuIE7DpHdl?= <stefan.naewe@atlas-elektronik.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Junio C Hamano <gitster@pobox.com>
Cc: "git@vger.kernel.org" <git@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git 1.7.8.rc0
References: <7vfwi9rc0g.fsf@alter.siamese.dyndns.org> <4EAEAE13.50101@atlas-elektronik.com>
In-Reply-To: <4EAEAE13.50101@atlas-elektronik.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 31.10.2011 15:17, schrieb Stefan Näwe:
> Am 31.10.2011 06:00, schrieb Junio C Hamano:
>> A release candidate Git 1.7.8.rc0 is available for testing.
>>
>> [...]
>>
>>
>> Git v1.7.8 Release Notes (draft)
>> ================================
>>
>> Updates since v1.7.7
>> --------------------
>>
>> [...]
>>
>>  * HTTP transport did not use pushurl correctly, and also did not tell
>>    what host it is trying to authenticate with when asking for
>>    credentials.
>>    (merge deba493 jk/http-auth later to maint).
> 
> This seems to break pushing with https for me.
> It never uses values from my '~/.netrc'.
> I'll come up with a detailed scenario later.

Update:

git push prompts for the password but just pressing return succeeds.

Weird...


Stefan
-- 
----------------------------------------------------------------
/dev/random says: Budget: A method for going broke methodically.
python -c "print '73746566616e2e6e616577654061746c61732d656c656b74726f6e696b2e636f6d'.decode('hex')"
