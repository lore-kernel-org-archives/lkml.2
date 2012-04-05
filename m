Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab2DEIZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 04:25:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37619 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab2DEIY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 04:24:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120404161317.GB14078@redhat.com>
References: <CANHD2=rF6dBkLLkWAj8uS3nq0B1wCt7Uvu=HzO84UNz2kuiaFg@mail.gmail.com>
	<20120313081235.GC15333@redhat.com>
	<CAErSpo6t-cVBdJfyARi3ifEuBUvopbG5GQSP5YywrvumDK8HFA@mail.gmail.com>
	<20120404161317.GB14078@redhat.com>
Date: Thu, 5 Apr 2012 09:24:56 +0100
Message-ID: <CANHD2=qW+9z7QCur8kZ_WJQsTi1x6tNwFsKa-V=4Ex7-QTxpgw@mail.gmail.com>
Subject: Re: Initializing iwl3945 error
From: Kamil Grzebien <ciptok@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, for lack of response. I've moved to new house recently and
don't have internet access there. Will update it ASAP.

BTW. I've checked 497f16f2 [pci: Fix hotplug of Express Module with
pci bridges] patch mentioned in https://lkml.org/lkml/2012/1/5/168 but
it doesn't solve my problem.

On Wed, Apr 4, 2012 at 5:13 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Thu, Mar 15, 2012 at 03:08:43PM -0600, Bjorn Helgaas wrote:
>> The bug report (http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2143)
>> has a lot of logs, but they're pretty old and I can't tell how
>> applicable they are to your situation.
>>
>> It would be useful to see a complete dmesg log, /proc/iomem, and
>> "lspci -vv" output from your machine after the problem occurs, and
>> also the same information when it works (when using the noapic flag).
>
> Kamil, ping, can you provide requested information?
>
> Stanislaw
