Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab1DSHqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 03:46:20 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38399 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1DSHqS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 03:46:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dSz51rDaq60gELG97bMEsf4OGliL9KN+bS8UN5pR6TGPsEidiFpmrohWYy1NMcUO+B
         N68tiGQ/0gRNzroP6EzZfHfaIk/sst1VJEntGKbGhzvzTfD+rxwsbOmA8q0IiC2n9Kv7
         vjEDD0K6jbyK0yr1EkAkH501m7Br5/S+ysibA=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=Ei91GRcL2oP0G16LDy7mpLoDEGQ@mail.gmail.com>
References: <BANLkTi=Ei91GRcL2oP0G16LDy7mpLoDEGQ@mail.gmail.com>
Date: Tue, 19 Apr 2011 15:46:17 +0800
Message-ID: <BANLkTi=-RnUyuC2VGuRix_J4KOx+9BhroQ@mail.gmail.com>
Subject: Re: [BUG] bluetooth doesn't work from 2.6.39-rc1+ to 2.6.39-rc3+
From: Dave Young <hidave.darkstar@gmail.com>
To: Hui Zhu <teawater@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Bluettooth Linux <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 10:53 AM, Hui Zhu <teawater@gmail.com> wrote:
> Cannot connect to any outside devices through bluetooth.
>
> And I think this is not a bug of low level driver.  Because both my
> laptop and a usb bluetooth card cannot work.

Hi, please explain the "cannot work" in detail,
Firstly check dmesg and hciconfig to see if there's anything wrong.

-- 
Regards
dave
