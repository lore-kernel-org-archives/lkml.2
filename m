Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab0GHUrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:47:37 -0400
Received: from smtp-out.google.com ([74.125.121.35]:27324 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab0GHUrg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:47:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Qz992nPUaP7TdQ6hKlS0zmz1SzpGveVnU6Oya1VQonfRSgw7ADUSuDc2LrRtDItGl
	MqVR6Iw2zUeIqc4tgyG1w==
MIME-Version: 1.0
In-Reply-To: <D3F292ADF945FB49B35E96C94C2061B90C317EA2@nsmail.netscout.com>
References: <AANLkTimvsaoOm_QEUnvlZf2EKuiMpOr9PdQt_Ga0Z97D@mail.gmail.com>
	<20100708012120.GB11419@auslistsprd01.us.dell.com>
	<D3F292ADF945FB49B35E96C94C2061B90C317EA2@nsmail.netscout.com>
Date: Thu, 8 Jul 2010 13:47:32 -0700
X-Google-Sender-Auth: Es9DjSVAcpef7-MvNbE0MugeEoc
Message-ID: <AANLkTikazGZZ6dDLpGQaRH7j-_M7hzinxmAP0TD84G2n@mail.gmail.com>
Subject: Re: nic enumeration
From: Andrew Fong <ayf@youtube.com>
To: "Loke, Chetan" <Chetan.Loke@netscout.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>,
       Michael Di Domenico <mdidomenico4@gmail.com>, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 8, 2010 at 1:36 PM, Loke, Chetan <Chetan.Loke@netscout.com> wrote:
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> owner@vger.kernel.org] On Behalf Of Matt Domsch
>> Sent: July 07, 2010 9:21 PM
>>
>> http://lwn.net/Articles/356900/
>>
>> And on a system where you can use udev rules, the
>> 70-persistent-net.rules file can be used to make them constant, by
>> using the MAC address to force the names to be what you want.
>>
>
> Ok, but can we achieve the renaming w/o a reboot?

You probably can restart the udev subsystem.

>
>
>> --
>> Matt Domsch
>
> Chetan Loke
> --
> To unsubscribe from this list: send the line "unsubscribe linux-net" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
