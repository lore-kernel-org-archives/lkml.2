Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab0FGRT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 13:19:29 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59781 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab0FGRT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 13:19:28 -0400
MIME-Version: 1.0
X-Originating-IP: [174.31.27.127]
In-Reply-To: <20100607162817.GA13468@phenom.dumpdata.com>
References: <AANLkTilOTKdY_2rQ6byxDIer_Ns-Ny0V0sM0rV9AuEkB@mail.gmail.com>
	<20100607162817.GA13468@phenom.dumpdata.com>
Date: Mon, 7 Jun 2010 10:19:27 -0700
Message-ID: <AANLkTim1KloQ4qZTsqHmt2U33dUjM-DDr9-dpooXTx52@mail.gmail.com>
Subject: Re: broadsheetfb and fbcon
From: Robert Emanuele <rob@emanuele.us>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, jayakumar.lkml@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no module parameters for fbcon or broadsheetfb.

On Mon, Jun 7, 2010 at 9:28 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Sat, Jun 05, 2010 at 04:21:08PM -0700, Robert Emanuele wrote:
>> Greetings lkml and Jaya,
>>
>> I've been using the broadsheetfb graphics driver for a while now.
>> I've been trying to get it working with the fbcon console driver.  Has
>> anyone had any success with that?
>>
>> While it "works", its performance is unusable as a console.  It
>> redraws the whole screen every new line, which may be acceptable.  A
>> real issue is when it tries to scroll the screen, it redraws each line
>> partially and then does a full screen update with each partial line.
>> It seems the driver is capable from Jaya's video at
>> http://www.youtube.com/watch?v=0Bny6qyRDWw
>>
>> Are those kind of updates a limit of the broadsheet driver or fbcon?
>
> I thought there was an update value on how often it should redraw. Did
> you do a modinfo on the driver?
>> Or more hopefully, is there a configuration change to improve this?
>
