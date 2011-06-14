Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab1FNJWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 05:22:12 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:37249 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab1FNJWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 05:22:08 -0400
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.129
X-Originating-IP: 93.93.133.68
Subject: Re: [PATCH] ideapad: let Fn+F5 also trigger KEY_BLUETOOTH
From: Bastien Nocera <hadess@hadess.net>
To: Ike Panhc <ike.pan@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Dmitry Torohov <dmitry.torokhov@gmail.com>
Date: Tue, 14 Jun 2011 10:21:59 +0100
In-Reply-To: <1308040109-12038-1-git-send-email-ike.pan@canonical.com>
References: <1308040109-12038-1-git-send-email-ike.pan@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1308043321.26522.4.camel@air.hadess.net>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 16:28 +0800, Ike Panhc wrote:
> The design for ideapad Fn-F5 key is not only for wifi but for all
> radio device including wifi, bluetooth and wwan. Idealy it shall
> acts like this:
> 
>     wifi on          wifi off         wifi on         wifi off
>      bt on   ----->   bt on   ----->   bt off  ----->  bt off
> 
> This patch will switch wifi mode every key-push and switch
> bluetooth mode every two key-push.

If that's what you want to achieve, then the key should be KEY_RFKILL.
That's what the key is there for.

