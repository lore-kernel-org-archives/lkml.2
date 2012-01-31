Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab2AaR0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 12:26:12 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53893 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab2AaR0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 12:26:11 -0500
Date: Tue, 31 Jan 2012 17:27:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: netdev@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Steve Glendinning <steve.glendinning@smsc.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Danny Kukawka <dkukawka@suse.de>
Subject: Re: [PATCH] smsc95xx: add macaddr module parameter
Message-ID: <20120131172731.03df5704@pyramind.ukuu.org.uk>
In-Reply-To: <1328030433-12524-1-git-send-email-danny.kukawka@bisect.de>
References: <1328030433-12524-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 18:20:33 +0100
Danny Kukawka <danny.kukawka@bisect.de> wrote:

> Added smsc95xx.macaddr module parameter to allow the user to
> change the MAC address on boot if there was no MAC on the EEPROM.

NAK. Please see the discussion on this and ifconfig hw for other devices.

In summary - make the device refuse to ifconfig up without a valid
address, allow it to come into existance without a valid address and then
use ifconfig.


Your patch also seems to break if there are several attached to a board.
