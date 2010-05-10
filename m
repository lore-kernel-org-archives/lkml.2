Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab0EJVIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 17:08:16 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:43841 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab0EJVIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 17:08:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BJ+7Z27OMst0/o4BTZ18/Rmv2yqgfLxjS+P6s8PRf9oJbdH6kKX17XQOuCfd3dzb2z
         LxKCdJwqFuThdnvQjfqWdHKujFfO9TKxB9+oBfg2KVBwa+eQyXz2wu9L1/LJ5SwyldH1
         y+GTtrkrkDuyatQjK36YZlCcGnsckFF2fQMVg=
Message-ID: <4BE875C8.8050202@gmail.com>
Date: Mon, 10 May 2010 14:08:24 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-bluetooth@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: magicmouse: claimed by neither input, hiddev nor hidraw
References: <j2idd18b0c31005101341o43b652c1zf8729f5f9a60e0d3@mail.gmail.com>
In-Reply-To: <j2idd18b0c31005101341o43b652c1zf8729f5f9a60e0d3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2010 01:41 PM, Justin Mattock wrote:
> is it me, or is there something wrong
> with the magicmouse connecting
> i.g. I've had my system setup to use the
> magicmouse with 2.6.33* with no issues
> now coming back after sometime
> seems everything is connecting,but then no movement:
> (and some thing in dmesg):
> [  116.267993] magicmouse 0005:05AC:030D.0007: claimed by neither
> input, hiddev nor hidraw
> [  116.268053] magicmouse 0005:05AC:030D.0007: magicmouse hw start failed
>
> using osx  magicmouse connects fine.
> Using standard mightymouse everything connects.
>   are there any reports of such things?
>
>

nevermind.. my bad, ended up not
having hiddraw enabled in the kernel.

everything looks good, suspend etc..

Justin P. Mattock
