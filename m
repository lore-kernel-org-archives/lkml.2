Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab2ECQWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 12:22:24 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34108 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756238Ab2ECQWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 12:22:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120503161736.GA16993@boyd>
References: <1336024803.10945.5.camel@lappy> <20120503161736.GA16993@boyd>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 3 May 2012 18:22:01 +0200
Message-ID: <CA+1xoqeVHH_8MezKFX=gB9o5zFMjajHAVai3SxGpzZpvQ5uUHw@mail.gmail.com>
Subject: Re: ecryptfs: Kernel BUG when closing device
To: Tyler Hicks <tyhicks@canonical.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, dustin.kirkland@gazzang.com,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ecryptfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 6:17 PM, Tyler Hicks <tyhicks@canonical.com> wrote:
> On 2012-05-03 08:00:03, Sasha Levin wrote:
>> Hi all,
>>
>> After some fuzzing using trinity inside a KVM guest, I've stumbled on the following:
>
> Hi Sasha - Thanks for reporting this issue. Is there any way to get
> trinity to reproduce this fuzzing sequence?

Hi Tyler,

Not really, since it's not the result of a single command it can't
recreate it easily.

On the other hand, I'd be happy to add any debugging ideas you have
into the tested kernel and attempt to recreate the issue.

Thanks.
