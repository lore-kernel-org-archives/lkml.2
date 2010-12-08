Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab0LHBrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:47:00 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:42780 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab0LHBq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:46:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eOu9LOm9j4eaxfj3BB0iC6kdb9v9IYknpAa1Qaj7I8oQ0oL9+abgm7SmLA9ketWQ28
         knYvMnoaQpQW3x+8BvJusijoP19g5AmOdrXKrbGk2uY0XbYr2HLP1eltfYtTdbBSwzc7
         hNt9P5GIZ6n+xiDhd0I5RZ2cyhHtb57Jn9p94=
Message-ID: <4CFEE38E.3020500@gmail.com>
Date: Tue, 07 Dec 2010 19:46:54 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Sanka Piyaratna <cesanka@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Posted Write onto a PCI end point device using Linux
References: <712019.56679.qm@web31702.mail.mud.yahoo.com>
In-Reply-To: <712019.56679.qm@web31702.mail.mud.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2010 05:29 AM, Sanka Piyaratna wrote:
> Hi,
>
>
> I am wondering whether it is possible to issue a posted write using the host
> computer's root complex towards an PCI express end point. I have done this using
>
> DMA in the past. However, if posted writes are possible that would save a lot of
>
> time and effort and would be quicker too.

Writes from the CPU to PCI memory are always posted. However, the posted 
write buffer size is usually quite limited and so this probably will 
still cause CPU overhead when writing any significant amount of data 
this way.
