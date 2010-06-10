Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955Ab0FJXzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 19:55:21 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47144 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab0FJXzQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 19:55:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Np8mdQ36+EcZ+n6OELTa1Ir8HO+5Cn36nV3fiKyek97T4pBTYQ4iPHucebGFd6jsx2
         yDkpo1Q2Q0nknzqvw/XkY9GjqTGyAtC21JNI0zILfpGIfSqFtFbsCRt/ZrgNo5I6MKkX
         8KCdx1hsxTwtHK+A7eQatUa2+AExk1/RNjXRY=
MIME-Version: 1.0
In-Reply-To: <20100610184023.GA17320@srcf.ucam.org>
References: <AANLkTinG3jv6o8T00mDTEP5uxf4tKqOwSPEDIUcv4kVG@mail.gmail.com> 
	<20100602213429.GA14866@srcf.ucam.org> <57DF5FDC2DC0634FA2A310BC5B81A68D01DF4CD01E@AUSX7MCPC108.AMER.DELL.COM> 
	<AANLkTimIl6UL0HQT1wxRgXuj_m0O3CwMHQIa1xNE1Ax9@mail.gmail.com> 
	<AANLkTin0qht1XR2rUgIXMEeJNU_gb3IZWqSBJb7NXD8K@mail.gmail.com> 
	<57DF5FDC2DC0634FA2A310BC5B81A68D01DFD57663@AUSX7MCPC108.AMER.DELL.COM> 
	<20100610184023.GA17320@srcf.ucam.org>
From: Islam Amer <pharon@gmail.com>
Date: Fri, 11 Jun 2010 02:51:53 +0300
Message-ID: <AANLkTilT3KCeJUpG-APK0MFh2ChMlZ4qwVPhOJpHnPB9@mail.gmail.com>
Subject: Re: Dell Studio 1555 eject key does not work ( small patch to fix 
	included )
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Rezwanul_Kabir@dell.com, linux-kernel@vger.kernel.org,
       platform-driver-x86@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

My bios version is A08 , I see that A11 was recently released but the
changelog doesn't say much.

Which is better, upgrade and hope the problem goes away, or wait until
we have a fix that is agreed upon ?

Thanks.

On Thu, Jun 10, 2010 at 9:40 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Thu, Jun 10, 2010 at 01:36:56PM -0500, Rezwanul_Kabir@Dell.com wrote:
>> Hi Islam Amer
>>
>>    I got report that "Ubuntu 10.04 + BIOS A11" was tested and the "Eject CD" key is working
>>    as expected. Sorry, I couldn't find any Studio 1555 to test myself and cannot provide you
>>    with more details.
>>
>>     Also, you may try acpi_osi="Windows 2009" kernel parameter and see if there is any difference.
>
> That's the default on any kernel that has this support in dell-wmi. Rez,
> could you let me know if the proposed patch breaks the spec in ways that
> are likely to cause problems?
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
>
