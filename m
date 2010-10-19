Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab0JSNbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:31:10 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:59052 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758542Ab0JSNbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:31:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=ac0Pr8
	Rh87ly1OwU2v6YZEjXt9z5bqTzDOwi5Z4ft6Fo5FxhS0Z66uvt9huIOfHEQLeJjg
	cA3ETAro4JTUw7z3XZ23QdL9FZnpUaxRUTJbOfpr585nvUlL8AmMlichfphM/6/v
	lMNP/WamGTl7Udy4GezAWSl/C3+uB0eg0yAk4=
Message-ID: <4CBD9D8C.3080302@pobox.com>
Date: Tue, 19 Oct 2010 22:30:52 +0900
From: Shinya Kuribayashi <skuribay@pobox.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US;
 rv:1.9.1.14) Gecko/20101005 Thunderbird/3.0.9
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>
CC: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 5/9] MIPS: sync after cacheflush
References: <17ebecce124618ddf83ec6fe8e526f93@localhost>
 <17d8d27a2356640a4359f1a7dcbb3b42@localhost> <4CBC4F4E.5010305@pobox.com>
 <AANLkTinpry=XG-ZDgXJK-VB6QkBL2TO4-vrsV5Tc1eEs@mail.gmail.com>
 <4CBCE05E.20408@renesas.com>
 <AANLkTinTaW87RGUZ+o4TL8gzUPGkoR8=7C1e7aYWC9=b@mail.gmail.com>
In-Reply-To: <AANLkTinTaW87RGUZ+o4TL8gzUPGkoR8=7C1e7aYWC9=b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 1E1DF384-DB85-11DF-B10A-89B3016DD5F0-47602734!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/10 9:51 AM, Kevin Cernekee wrote:
> Correct.  This particular system makes no guarantees that data flushed
> out through CACHE operations will not overtake subsequent uncached
> stores.

Thanks for the clarification, understood.  So we only need to take care
of the order of out-bound data write transactions at the processor end,
and preceding uncached load is not required here.   Sorry for the noise.

   Shinya
