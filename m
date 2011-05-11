Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab1EKW4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:56:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51009 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab1EKW4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:56:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RSkJebkLEioANz6X2GnBJ+OT2oKfvn4oqFWkqahn9x/m2f2zgKSjn3loMIq6jw3lp5
         6GV1GT1FECIxX2cT42vVhgc4Q1fWJKshc4HjSq9A46wHy/6nxZDfdRr4X4Rpd+8WQYI8
         IHUuj7KRMgAZZXGYs3b0FM10KoJc9Zbx2jgZQ=
MIME-Version: 1.0
In-Reply-To: <20110511210837.GA4893@kroah.com>
References: <cover.1305103212.git.mfm@muteddisk.com>
	<3a932c55376e57a96881a654a0f6c3e6837f400e.1305103212.git.mfm@muteddisk.com>
	<20110511210837.GA4893@kroah.com>
Date: Wed, 11 May 2011 15:56:04 -0700
Message-ID: <BANLkTikg-oZrevgm-g+M=FO+O-uj5OyaEQ@mail.gmail.com>
Subject: Re: [PATCH 06/12] staging: usbip: stub_main.c: code cleanup
From: matt mooney <mfmooney@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 2:08 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, May 11, 2011 at 01:54:18AM -0700, matt mooney wrote:
>> Reorder functions; remove match_find() and replace with
>> get_busid_idx(); change other functions to use get_busid_idx(); and
>> code cleanup in the other functions.
>>
>> Signed-off-by: matt mooney <mfm@muteddisk.com>
>> ---
>> I apologize for this one. I realize that I should have split it into two with
>> the reorder being separate.
>
> Yes, please split it up.

Okay, I have to try and figure out a sane way of doing this but I will split it.

>> Also, it seems as if there is a synchronization problem carried over from the
>> original code in get_busid_priv(). An address into the busid_table is returned
>> and then the element is accessed and modified elsewhere. Right? Or am I missing
>> something.
>
> You might be correct, I don't really know.
>
Yeah I will have to figure that out as I go.

-- 
GPG-Key: 9AFE00EA
