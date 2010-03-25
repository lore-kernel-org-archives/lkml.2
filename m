Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab0CYVOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 17:14:48 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:59257 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab0CYVOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 17:14:47 -0400
Message-ID: <4BABD245.8050300@msgid.tls.msk.ru>
Date: Fri, 26 Mar 2010 00:14:45 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.33: Xorg+khubd lockup (D-state) BUG / ioctl EVIOCGNAME failed:
 Inappropriate ioctl for device / PreInit returned NULL
References: <Pine.LNX.4.44L0.1003251646170.1808-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1003251646170.1808-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Thu, 25 Mar 2010, Justin Piszcz wrote:

Actually this very message - ioctl EVIOCGNAME...NULL - is quite
common since some time - since either some of X or kernel.
But usually it does not come together with a freeze, and
it is not necessary about USB to start with -- for example,
my synaptics touchpad stopped working, and that's exactly
what's shown in the Xorg.log file -- EVIOCGNAME..NULL, when
it tries to init the touchpad...  JFYI.

/mjt
