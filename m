Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242Ab1JFTvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 15:51:17 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51870 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759204Ab1JFTvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 15:51:15 -0400
MIME-Version: 1.0
In-Reply-To: <20111006194156.GA21627@kroah.com>
References: <1317928788.76722.YahooMailNeo@web30301.mail.mud.yahoo.com>
	<20111006194156.GA21627@kroah.com>
Date: Thu, 6 Oct 2011 15:51:14 -0400
Message-ID: <CA+5PVA45jCyk0xZpkxd7dzx6v4HhkYJLFT4VrrgC5d30WAgORQ@mail.gmail.com>
Subject: Re: acm/ttyACM0/cdc_acm does not deliver data
From: Josh Boyer <jwboyer@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: AW <arne_woerner@yahoo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 6, 2011 at 3:41 PM, Greg KH <greg@kroah.com> wrote:
> On Thu, Oct 06, 2011 at 12:19:48PM -0700, AW wrote:
>> Hi!
>>
>> I made some USB devices using the CDC-ACM proposal...
>> They work fine with 2.6.38.8-35.fc15/amd64 and earlier.
>>
>> But since 2.6.40-4.fc15/amd64 it doesnt work as before...
>
> Can you try a kernel.org release instead of a Fedora kernel?  Does this
> work on 3.0.6?

He's tried 2.6.40.6, which is analogous to 3.0.6.  It still fails
according to the report.

Your suggestion of using a vanilla kernel is fine, but I wouldn't
expect different results.  We have a fairly small set of patches, none
of which seem to jump out as impacting this.

josh
