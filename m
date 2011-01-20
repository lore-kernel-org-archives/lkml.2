Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab1ATVSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:18:07 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:2334 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab1ATVSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:18:05 -0500
Message-ID: <4D38A687.7010300@caviumnetworks.com>
Date: Thu, 20 Jan 2011 13:17:59 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Artur Baruchi <mail.baruchi@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Time Track
References: <AANLkTimP7kZnv=YrhHbeHtYHUYYuyf1GHLZ9wu_KTE_H@mail.gmail.com>
In-Reply-To: <AANLkTimP7kZnv=YrhHbeHtYHUYYuyf1GHLZ9wu_KTE_H@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jan 2011 21:18:04.0819 (UTC) FILETIME=[86C4C630:01CBB8E7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 11:50 AM, Artur Baruchi wrote:
> Hi Guys.
>
> I would like to know how long a function in a ginven kernel module is
> taking to run. Is there a way to measure this?

Of course there is.  Use the Function Graph tracer.

An alternative would be a kretprobe

> I've checked in some
> books about kernel programming but dindt find it.
>

Study ftrace and kprobes.

David Daney

> Thanks in advance.
>
> Att.
> Artur Baruchi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

