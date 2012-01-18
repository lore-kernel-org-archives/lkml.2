Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab2ARBrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 20:47:19 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:65025 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755528Ab2ARBrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 20:47:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=O1nS1pqy1f7ljXRMiLqaiUT1P3Zf8maQ
	BQzqU1GzF/OBrLSlBnvqFY1LmFQc02IiRSHGHyxf1DVGrdSPoPM1etKlraKVUTfc
	GwsgjO4zwC1j+6jKK7A2KjnCy5IrjutmOM2e4erUESCYEZY2fkLrSfWTMxVMeL3j
	mvEOBN92xWY=
From: Junio C Hamano <gitster@pobox.com>
To: Andrew Ardill <andrew.ardill@gmail.com>
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Using signed tag in pull requests
References: <7vehuyosaa.fsf@alter.siamese.dyndns.org>
 <CAH5451nSMcJ50fu2qtMkw4zPpx-Kg-k-jqCcpryu+pkC8JX8rw@mail.gmail.com>
Date: Tue, 17 Jan 2012 17:47:15 -0800
In-Reply-To: <CAH5451nSMcJ50fu2qtMkw4zPpx-Kg-k-jqCcpryu+pkC8JX8rw@mail.gmail.com> (Andrew
 Ardill's message of "Wed, 18 Jan 2012 12:07:18 +1100")
Message-ID: <7vwr8pok7w.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 59EB689E-4176-11E1-8E61-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Ardill <andrew.ardill@gmail.com> writes:

>> Starting from Git release v1.7.9, a contributor can add a signed tag to
>> the commit at the tip of the history and ask the integrator to pull that
>> signed tag. When the integrator runs `git pull`, the signed tag is
>> automatically verified to assure that the history is not tampered with.
>> In addition, the resulting merge commit records the content of the signed
>> tag, so that other people can verify that the branch merged by the
>> contributor was signed by the contributor, without fetching the signed tag
>
> I think you mean to say 'the branch merged by the integrator was signed
> by the contributor'.

Definitely. I'll update my local copy.

Thanks for spotting this.


