Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab2JCATt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 20:19:49 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36878 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932882Ab2JCATr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 20:19:47 -0400
MIME-Version: 1.0
In-Reply-To: <20121002122325.GV4587@mwanda>
References: <1349178827-29643-1-git-send-email-yamanetoshi@gmail.com>
	<1349178888-29716-1-git-send-email-yamanetoshi@gmail.com>
	<20121002122325.GV4587@mwanda>
Date: Wed, 3 Oct 2012 09:19:46 +0900
Message-ID: <CAOTypNRF5=RgKYM=GHKbK14OQe4hO5jxiwTGB7zhBbkckgeKMQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] Fix line over 80 character issue and space before
 tabs issue in trace.h
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 9:23 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Tue, Oct 02, 2012 at 08:54:48PM +0900, YAMANE Toshiaki wrote:
>> fixed some checkpatch warnings.
>>
>> -WARNING: line over 80 characters
>> -WARNING: please, no space before tabs
>>
>
> These looked nicer in the original, sorry.

I will destroy this patch series.
thanks.


YAMANE Toshiaki
