Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab2KZXob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 18:44:31 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39901 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2KZXo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:44:29 -0500
Message-ID: <50B3FED8.7090100@gmail.com>
Date: Tue, 27 Nov 2012 00:44:24 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Joe Millenbach <jmillenbach@gmail.com>, Alan Cox <alan@linux.intel.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCHv3] tty: Added a CONFIG_TTY option to allow removal of
 TTY
References: <1353033035-4928-1-git-send-email-jmillenbach@gmail.com> <20121126233824.GA8868@kroah.com>
In-Reply-To: <20121126233824.GA8868@kroah.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 12:38 AM, Greg Kroah-Hartman wrote:
> Can you rediff this once 3.8-rc1 is out and send it to me then?

So if you are going to respin, please take care of the newly added
drivers like drivers/staging/fwserial.

thanks,
-- 
js
