Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab0IHAFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 20:05:11 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63604 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab0IHAFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 20:05:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YKBnmUhIXYau5ptoUbxL3Bv7CtIuYR30B1Ehkso1SF1cXfQ4g+vjJtx0xFsDFo98mO
         7NCUTEH1zx0Rmdo6W52bPdNrBpLvMRXXYtbWCA0+zcodbJ8FXh2XXt5LxrYyuvxlZfTb
         W8iPiakYI0Q3LFFIspnkisDABNB1FhIPAKfUQ=
MIME-Version: 1.0
In-Reply-To: <20100907232957.GA11595@electric-eye.fr.zoreil.com>
References: <AANLkTinK4VywsJ86jaC8wQjbXjzvP-z44JD3XbZbMM2a@mail.gmail.com>
	<20100907232957.GA11595@electric-eye.fr.zoreil.com>
Date: Tue, 7 Sep 2010 17:05:08 -0700
Message-ID: <AANLkTi=-o68GqqvOeQgEBThBJo=v2kUEy4+VDU14b3us@mail.gmail.com>
Subject: Re: Is via-velocity broken in 2.6.34?
From: Matt Causey <matt.causey@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: linux-kernel@vger.kernel.org,
        Simon Kagstrom <simon.kagstrom@netinsight.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 7, 2010 at 4:29 PM, Francois Romieu <romieu@fr.zoreil.com> wrote:
> Please Cc: netdev@vger.kernel.org

Done, cheers for that I didn't know.

>
> Matt Causey <matt.causey@gmail.com> :
> [2.6.29 -> 2.6.34 regression]
>> Attached is debug.tar.  It contains dmesg, config.gz, ethtool,
>> ifconfig, and lspci output.  I'm not sure what else to do at this
>> point.  Is there some debugging I can enable in the kernel to give
>> more clues as to what's gone wrong?
>
> Any chance you could bisect the regression or narrow it down a bit ?
>

I've never bisected before.  But I'll lookup some documentation and
give it a go.  :-)

> Otherwise may I assume that there is no difference in the
> userspace tools (just in case) ?
>

That's a valid assumption.  The userland was exactly the same, just
different kernel version.

--
Matt
