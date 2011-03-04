Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab1CDWQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 17:16:46 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49882 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab1CDWQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 17:16:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=d+Gztny5r+eGU2+TCZOHyZI0MeNhU0p7F2XqtpwUrUN+I0PaZ+e/vYfBRKeirmMOFr
         9ugr/mM+9w38MeOcftEJq57cfYkNR8gaWLVYFJ5AbTpcubMntp93RBRruy5iGAD9tRxx
         sAdKcwbedWJSh55GTYWae2/XIAUKEeqvjvydI=
MIME-Version: 1.0
In-Reply-To: <4D70880C.4000209@zytor.com>
References: <ded07e5c09d72da478c6218658095f5a.squirrel@deadhat.com>
	<AANLkTimg1x56B4Yu=Zsd0VEci2i4jRKaMU+gxv3oFVr8@mail.gmail.com>
	<20110301235433.GD2959@thunk.org>
	<4D6EBC04.5050709@zytor.com>
	<4D7078C8.8050009@deadhat.com>
	<4D70880C.4000209@zytor.com>
Date: Fri, 4 Mar 2011 14:16:43 -0800
X-Google-Sender-Auth: -QYzS6W8wKuoIfP-cH6G_khkixU
Message-ID: <AANLkTim6utrJZ-jVJdNJA6Ea_f8xQ-eAaGX8yfBaT9oc@mail.gmail.com>
Subject: Re: Why is my copyright code in the linux kernel?
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Johnston <dj@deadhat.com>, tytso@mit.edu,
        richard.weinberger@gmail.com, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 10:34 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/03/2011 09:29 PM, David Johnston wrote:
>> Yes I am willing to allow you to retain it.
>> I guess, to be all legalese..
>>     I herein permit you to use any 802.11 related C code taken from the
>> www.deadhat.com website, in the linux kernel, and to publish it under
>> the terms of version 2 of the GNU General Public License.
>>
>> Yes I've emailed ralink and VIA. I hope they're nice people.
>
> First of all, thank you (both for the code and for being reasonable.)
>
> It sounds like this might simply have been an honest misreading.
>

interesting.

in the git history, some functions take IN/OUT macro.

-VOID AES_GTK_KEY_UNWRAP(IN UCHAR * key,
-                       OUT UCHAR * plaintext,
-                       IN UINT32 c_len, IN UCHAR * ciphertext)

so they had driver for other os at first, and ported that one to Linux later ?

Yinghai
