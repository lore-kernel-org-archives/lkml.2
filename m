Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393Ab1BOFEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 00:04:36 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59280 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab1BOFEe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 00:04:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OdcEV56kMMU28Zg63Q8NDJTlh3HeCd12dowEKZ3sIQ8/hCqNvh8imEu3pv5ZCqmycK
         lSnQtc0MCcInPH9hlJeWCU5oZUSHCXV1JiKxHyhKswIIYs9sMjF5wM7ClA2aSdW3cMKX
         UAe0Xx/AsoiWRTzv1gNo8FtTPnsdsTWS0LII0=
MIME-Version: 1.0
In-Reply-To: <20110215011102.GA14825@pad.home.fieldses.org>
References: <AANLkTinW7mWsrgwY2JsG9U-Qk1icKyApbdVJvavw4iGZ@mail.gmail.com>
	<20110215011102.GA14825@pad.home.fieldses.org>
Date: Mon, 14 Feb 2011 21:04:31 -0800
Message-ID: <AANLkTim_Xaik8enPNhs+x8+dBQ2Ya+fSpYP534LkpitT@mail.gmail.com>
Subject: Re: kernel BUG at fs/nfsd/nfs4state.c
From: Bret Towe <magnade@gmail.com>
To: "J. Bruce Fields" <bfields@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 5:11 PM, J. Bruce Fields <bfields@redhat.com> wrote:
> On Sun, Feb 13, 2011 at 02:12:06PM -0800, Bret Towe wrote:
>> got this bug shortly after a fresh boot into 2.6.38-rc4 a nfs client
>> at the time was logging into its nfs home
>> the server is a 32bit setup running debian squeeze
>> the client at the time was 64bit debian squeeze (also running 2.6.38-rc4)
>> and the output below is from the server
>>
>> let me know if you need more info and I can do tests if required
>
> This is a known bug.  It should be fixed in
>
>        git://linux-nfs.org/~bfields/linux.git for-2.6.38
>
> --b.
>

yeah looks to be fixed nfs client is able to login and have done some
other minor
things and see no errors

thanks
