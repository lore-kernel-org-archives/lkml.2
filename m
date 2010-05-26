Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab0EZFvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 01:51:37 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38441 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0EZFvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 01:51:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GSJ5HdMuI44YLqsm2o8t6qbjuqoLEJH44k7qIoWfvWxZUcQ4HqkvOXuONkRqwih08f
         fjpav23iJsxf+CKzYyaIrhLiSlG9tbnsM6na1u+WPtC4CUQsiW4wu2BmlDI2CNVkfll/
         FbeFWCBTzWFvkxoH/Kt/8l0BSNPYa9RNS2g38=
Date: Wed, 26 May 2010 13:55:27 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: ranjith kumar <ranjithproxy@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: building linux kernel
Message-ID: <20100526055222.GG5147@cr0.nay.redhat.com>
References: <AANLkTim7d3LpSp23LMOqwPz-Rnp0Idflf5JWUTDyplMU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim7d3LpSp23LMOqwPz-Rnp0Idflf5JWUTDyplMU@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 04:50:31PM +0530, ranjith kumar wrote:
>Hi,
>
>I am using fedora11 on my PC. I downloaded the linux kernel souce code.
>I copied config file from /boot directory and tried to compile. I am
>getting some compilation errors.

Which version of kernel did you download?


>So  I configured the kernel, with 'make defconfig', and it is
>compiling successfully.


This may be dangerous, because default config may not contain
the drivers needed by your machine.

You should copy the fedora config and then do 'make oldconfig',
or you can use 'make localmodconfig' if you are compiling
a recent kernel.

>
>Also, some time back when I was using fedora10, I configured linux
>kernel with /boot/ config file. I successfully compiled and run new
>linux kernel.

This is what supposed to be.

