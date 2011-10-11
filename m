Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab1JKQ0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 12:26:09 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38353 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab1JKQ0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 12:26:08 -0400
MIME-Version: 1.0
In-Reply-To: <20111011161153.GA6697@suse.de>
References: <1318260152-2786-1-git-send-email-mark.einon@gmail.com>
 <CAP2e6W9oQWLxe7pJxk=Awn1HTueeu41ZV7TFF+V9tHF07_Mxag@mail.gmail.com> <20111011161153.GA6697@suse.de>
From: Mark Einon <mark.einon@gmail.com>
Date: Tue, 11 Oct 2011 17:25:47 +0100
Message-ID: <CANK3SE1tdJm93BK+U01Ep7Q2B=+aUJmgxkrQ537oPrqB2YZ4nA@mail.gmail.com>
Subject: Re: [PATCH 4/4] staging: et131x: Update TODO list
To: Greg KH <gregkh@suse.de>
Cc: Ramesh R <rshlinux@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 October 2011 17:11, Greg KH <gregkh@suse.de> wrote:
> On Tue, Oct 11, 2011 at 09:00:35AM -0700, Ramesh R wrote:
>> Hi Mark,
>>
>> I wish to contribute to this project - From the latest TODO list in
>> the README document
>>
>> drivers/staging/et131x/README
>>
>> If I were to start with the coding style cleanups, is there a coding
>> standard available for reference? Please advice.
>
> Documentation/CodingStyle
>
Ramesh,

There are no significant coding style issues with this particular
driver at this time, as far as I (and the checkpatch script) are aware
of.
I suggest you check other staging/ drivers for these sorts of issues.

Cheers,

Mark
