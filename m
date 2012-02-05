Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab2BEGHA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 01:07:00 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41216 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab2BEGG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 01:06:58 -0500
MIME-Version: 1.0
In-Reply-To: <201202042327.10045.rjw@sisk.pl>
References: <20120201223105.6669.12718.stgit@srivatsabhat.in.ibm.com>
	<4F29C3E3.1040108@linux.vnet.ibm.com>
	<4F2D3C90.3000708@linux.vnet.ibm.com>
	<201202042327.10045.rjw@sisk.pl>
Date: Sun, 5 Feb 2012 14:06:56 +0800
Message-ID: <CAJd=RBDz6bm-2p28506+0CuC3P6kED8kXLrZe_TPuhTQSUo67w@mail.gmail.com>
Subject: Re: [PATCH Updated] PM/Freezer: Thaw only kernel threads if freezing
 of kernel threads fails
From: Hillf Danton <dhillf@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, pavel@ucw.cz, len.brown@intel.com,
        linux-pm@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Nigel Cunningham <nigel@tuxonice.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 5, 2012 at 6:27 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, February 04, 2012, Srivatsa S. Bhat wrote:
>> On 02/02/2012 04:29 AM, Srivatsa S. Bhat wrote:
>> Hi Rafael,
>>
>> I have reworked the changelog of this patch to indicate that this fixes a
>> regression. Here is the updated patch:
>
> Well, I've already fixed that up in my tree, but thanks anyway. :-)
>

Nicer if gurus open wider windows for patches received, no?

Good weekend
Hillf
