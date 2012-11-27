Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab2K0Cg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 21:36:59 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:65421 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab2K0Cg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 21:36:58 -0500
MIME-Version: 1.0
In-Reply-To: <50B3FED8.7090100@gmail.com>
References: <1353033035-4928-1-git-send-email-jmillenbach@gmail.com>
	<20121126233824.GA8868@kroah.com>
	<50B3FED8.7090100@gmail.com>
Date: Mon, 26 Nov 2012 18:36:57 -0800
Message-ID: <CADwDc1CtMuwv6R4asdG9MnT-=Fasj7cWtLA4xf9UFWRUeAjQsg@mail.gmail.com>
Subject: Re: [PATCHv3] tty: Added a CONFIG_TTY option to allow removal of TTY
From: Joe Millenbach <jmillenbach@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 3:44 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 11/27/2012 12:38 AM, Greg Kroah-Hartman wrote:
>> Can you rediff this once 3.8-rc1 is out and send it to me then?
>
> So if you are going to respin, please take care of the newly added
> drivers like drivers/staging/fwserial.
>
> thanks,
> --
> js

Will do on both counts (wait until 3.8-rc1, rebase, and search for TTY
uses in new drivers).

- Joe Millenbach
