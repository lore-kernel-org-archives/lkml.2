Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab1CNOBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 10:01:32 -0400
Received: from smtp-out.google.com ([74.125.121.67]:25940 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1CNOBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 10:01:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lXMU2tyvIsOlat+sZ74S5bfdSQObS4DknhP/cCOzQRTrdebUX1nMFPIEnCkriHWwVR
         q/Gh0/5Tx/bAxt4o4jCQ==
MIME-Version: 1.0
In-Reply-To: <20110314092220.GA18058@elte.hu>
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
 <20110312014358.6133.34911.stgit@mike.mtv.corp.google.com>
 <4D7D9F92.5010604@kernel.org> <AANLkTik5iAPou_bPa4xk6iR27sOk2yrexaaTUe-g=VEe@mail.gmail.com>
 <4D7DA16F.5010601@kernel.org> <20110314092220.GA18058@elte.hu>
From: Tim Hockin <thockin@google.com>
Date: Mon, 14 Mar 2011 07:01:02 -0700
Message-ID: <AANLkTikXE+rMj1GHqZq6YpZOj1_PQJ-K4t8WeVKgsG_B@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] driver: Google Memory Console
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Mike Waychison <mikew@google.com>,
        Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        San Mehat <san@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This same BIOS logic is used across a number of Platforms.  We could
use something like the vendor strings to trigger this code off, I
suppose, but ick.  It's already in a google/ subdir and wrapped with
CONFIG_GOOGLE_MEMCONSOLE.



On Mon, Mar 14, 2011 at 2:22 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * H. Peter Anvin <hpa@kernel.org> wrote:
>
>> On 03/13/2011 09:58 PM, Tim Hockin wrote:
>> > "Sufficient" or not, that's how the BIOSes we've got work.  We can't
>> > retrofit that.
>>
>> Uhm... what about, say, a DMI signature?
>
> Yes - how does the dmidecode output look like on such a box?
>
> Thanks,
>
>        Ingo
>
