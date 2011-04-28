Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394Ab1D1SGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 14:06:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49428 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901Ab1D1SGA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 14:06:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vTZgMAUvAQn1/WtxUNtQFJj+Tjd/MFxAbEteQQvTCgkD3l05sg9I7piOdIQvq3SbuW
         bNsv2xWz69qxucklMawNnq7CAPO1x1rHhpic4nmbwZrFqaJ8ejeaTvBIGPPtm18571US
         uZq2BoG3cvcQ/MyLP92rsP9zGHSvgzh14QzjU=
MIME-Version: 1.0
In-Reply-To: <4DB9884F.10409@lwfinger.net>
References: <4db8436a.NDzkd3ql2wJdwy2L%Larry.Finger@lwfinger.net>
	<20110428150819.GA3713@spotteswoode.de.eu.org>
	<4DB9884F.10409@lwfinger.net>
Date: Fri, 29 Apr 2011 02:05:56 +0800
Message-ID: <BANLkTin7Nw1ZjK8UHfypHXY5ZuzafXnJbQ@mail.gmail.com>
Subject: Re: [PATCH] staging: r8712u: Fix driver to support ad-hoc mode
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: clemens fischer <ino-news@spotteswoode.dnsalias.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, wlanfae@realtek.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 11:31 PM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:
> On 04/28/2011 10:08 AM, clemens fischer wrote:
>> This patch doesn't solve my problem[1], unfortunately.  I am using
>> iwconfig(8) to setup things, and it is still impossible to set the ESSID
>> and the power saving mode.  In my case it was even possible to get into
>> Ad-hoc mode without the patch and without ever beeing associated.

iwconfig doesn't work by itself to set adhoc mode (I haven't figure
why either). You can get into "adhoc mode", but you won't see
ESSID:XXXX.

Can you please try "wpa_supplicant" instead?


Jeff
