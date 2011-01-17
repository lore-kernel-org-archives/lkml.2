Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab1AQIu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 03:50:27 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:33901 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab1AQIu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 03:50:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QfSMupX5wAS/uarHtuSpW4z2z1MFgD6VKw3M5i8UTepBBmucBpZjIjcizgFg7SemwV
         hszXjfsdEN1Q0+D3QsqDxdyjl3y+2+4p7W7jJY0zTCmyODJZzLWIRBXdHfrIsQrzuKHR
         M0uuCEQt5BTCHOCncDVx6IcZ2SVghOGy6buJ0=
Date: Mon, 17 Jan 2011 16:50:16 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jeffrey Merkey <jeffmerkey@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [UPDATE] gcc NULL strings passed from ternary operators in
 kernel modules
Message-ID: <20110117085016.GG11358@cr0.nay.redhat.com>
References: <AANLkTim+fY4jUoE_8zVkZ2xxZ+nT3_SeMrOvwW6714z9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim+fY4jUoE_8zVkZ2xxZ+nT3_SeMrOvwW6714z9@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 12:56:39AM -0700, Jeffrey Merkey wrote:
>might help if my examples are correct -- geez...
>
>interesting case with gcc.  The following code example:
>
>printk("%s\n", (value & 1) ? "set": "clear");
>
>will evaluate to NULL unless the ":" character has a space after
>static string declaration.
>
>this version
>
>printk("%s\n", (value & 1) ? "set" : "clear");
>
>works.
>
>go figure.   Looks like gcc assumes this case is a C++ construct of
>some sort and
>evaluates it to NULL.
>

Huh? How can gcc assume that is C++ code?!
Whitespaces definitely should not bother the code.

Which version of gcc are you using?

