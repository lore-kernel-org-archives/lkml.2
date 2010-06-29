Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab0F2Xll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 19:41:41 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41849 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab0F2Xlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 19:41:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fb+5BZlaBvaMZmAQ/NlVErqsbiC0OTU3am4UEqZyTpegXWP3BzfwW7uN6Ckbd4dTeB
         Qpb8D2NPVdZdLnEBH9CChUBj7GqdXeOp2lGhijZX2pdiwt+oaHmGCFecppNY81tkseLJ
         tEevr6c2BbCjK5MR2f+sWSSjjRqglxfIBTCQs=
MIME-Version: 1.0
In-Reply-To: <4C2A6921.1010405@codemonkey.ws>
References: <AANLkTinl3ighc51F5V4YP7fuOSscAA_qcynYMtM5j5wk@mail.gmail.com>
	<4C2A6921.1010405@codemonkey.ws>
Date: Tue, 29 Jun 2010 19:41:38 -0400
Message-ID: <AANLkTilmsaCdFN6Wjrea92hyj2V8WtcVmL49FFbztxDE@mail.gmail.com>
Subject: Re: Hypervisor detection from within a Linux VM
From: Chetan Loke <chetanloke@gmail.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 5:44 PM, Anthony Liguori <anthony@codemonkey.ws> wrote:
> On 06/29/2010 04:25 PM, Chetan Loke wrote:
> It can be done entirely in userspace.  Take a look at virt-what:
>
> http://people.redhat.com/~rjones/virt-what/
>

Just posted a patch for virt-what.in which can be used as a wrapper
script. I will be using that for now.

>> Question:
>> Q1)Is it possible to get this functionality as part of the stock
>> kernel or is that a bad idea? I suspect there could be other
>> users/apps who would need to know what *nix hypervisor(or a
>> non-virtualized environment) they are
>> running on?
>
> It might be reasonable to list the hypervisor signature as a field in
> /proc/cpuinfo.  There's also a /sys/hypervisor where such information could
> go.
>

I like the idea of spitting out a signature under /proc/cpuinfo
primarily because everyone is familiar with that node.

> Regards,
> Anthony Liguori

Regards
Chetan Loke
