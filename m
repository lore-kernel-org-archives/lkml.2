Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab1HBWCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 18:02:04 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25825 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab1HBWB5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 18:01:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=dj9Qip2Z6KndK9J4ws/QTwDmwwiPqCMbcLdW9r7XZVsmRfgyto0ZAQ1v5gzjuX3Rf
	qLveUq1UwuzeegTbZAISg==
MIME-Version: 1.0
In-Reply-To: <20110802210326.GA2606@srcf.ucam.org>
References: <4e3864a227625bd7d6@agluck-desktop.sc.intel.com> <20110802210326.GA2606@srcf.ucam.org>
From: Mike Waychison <mikew@google.com>
Date: Tue, 2 Aug 2011 15:01:33 -0700
Message-ID: <CAGTjWtAK9tv9BpsjizN26aT2EheU-o8gYetzWVNxV+W8z8Nn9g@mail.gmail.com>
Subject: Re: [PATCH] efivars: fix warnings when CONFIG_PSTORE=n
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 2, 2011 at 2:03 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Aug 02, 2011 at 01:57:06PM -0700, Luck, Tony wrote:
>> drivers/firmware/efivars.c:161: warning: ‘utf16_strlen’ defined but not used
>> utf16_strlen() is only used inside CONFIG_PSTORE - put same #ifdef around the
>> definition of the function too.
>>
>> drivers/firmware/efivars.c:602: warning: initialization from incompatible pointer type
>> Between v1 and v2 of this patch series we decided to make the "part" number
>> unsigned - but missed fixing the stub version of efi_pstore_write()
>>
>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>
> Acked-by: Matthew Garrett <mjg@redhat.com>

Acked-by: Mike Waychison <mikew@google.com>
