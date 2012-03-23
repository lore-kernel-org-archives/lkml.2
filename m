Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab2CWQxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 12:53:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48633 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2CWQxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 12:53:06 -0400
Message-ID: <4F6CAA6E.4070401@wwwdotorg.org>
Date: Fri, 23 Mar 2012 10:53:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <willy@meta-x.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Regression due to: net/usbnet: avoid recursive locking in usbnet_stop()
References: <4F6BAE34.7010805@wwwdotorg.org> <CACVXFVMPqXr+AuoBj9R5Fk=_UOPaozm2ok9zd9N-_JUOe8cu4g@mail.gmail.com>
In-Reply-To: <CACVXFVMPqXr+AuoBj9R5Fk=_UOPaozm2ok9zd9N-_JUOe8cu4g@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 09:28 PM, Ming Lei wrote:
> On Fri, Mar 23, 2012 at 6:56 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> It looks like commit 4231d47e6fe69f061f96c98c30eaf9fb4c14b96d
>> "net/usbnet: avoid recursive locking in usbnet_stop()" causes a problem
>> for me.
>>
>> When I reboot or shutdown, I see the error spew below at least 50% of
>> the time. Reverting the above patch fixes this, at least for 10 reboot
>> attempts.
> 
> The two patches[1][2] should fix your problem, please try them.
> Both have been applied into David's tree.
> 
> [1], http://marc.info/?l=linux-usb&m=133242262312402&w=2
> [2], http://marc.info/?l=linux-usb&m=133242264412410&w=2

Those two patches do solve the problem I was seeing, thanks.

FWIW, too late, but:
Tested-by: Stephen Warren <swarren@wwwdotorg.org>
