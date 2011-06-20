Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab1FTLUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 07:20:18 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42005 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab1FTLUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 07:20:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jPUnSqhY50wzy8/fqteDgDtQy/Ozgynk1FCRJ/TcBdCaUcUMvNswNPPo4n0qt0WC/K
         NiNgbom2fkLEAcle3LXSYaHoxPZa2UkYJfHqVvNLDY3M9oQPz2waX+CH41WtI5aZnk6q
         mFcYZoa5dGIYHkWsAm4IdAryHYjiIOUttJuQ8=
MIME-Version: 1.0
In-Reply-To: <8739j59zib.fsf@rustcorp.com.au>
References: <1308434431.1050.5.camel@mop> <8739j59zib.fsf@rustcorp.com.au>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 20 Jun 2011 13:20:00 +0200
Message-ID: <BANLkTink8YTe=-Tr5Ax3epiFoFCfzcex7w@mail.gmail.com>
Subject: Re: module: sysfs - add 'uevent' file to allow coldplug
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 01:23, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Sun, 19 Jun 2011 00:00:29 +0200, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> From: Kay Sievers <kay.sievers@vrfy.org>
>> Subject: module: sysfs - add 'uevent' file to allow built-in coldplug
>>
>> Userspace wants to manage module parameters with udev rules.
>> This currently only works for loaded modules, but not for
>> built-in ones.
>
> I'm confused.  What does "manage" mean here?

Hook system management into module-load events, which might include
changing module parameters in /sys/module/*/parameters/*, or at
bootup/coldplug run it for built-in modules.

We do the same to set properties for buses, drivers or devices when they appear.

Kay
