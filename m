Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab0ITTfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:35:50 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41358 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab0ITTfr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:35:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=pLa17YCUjkRzTk4bj9OGhxeJJ71Et0lA+Jm5uMcdERW3OuqebGuqrHOd2nempOJ1gT
         AWU7gBeT4+QRcD4qjVzYXPkQPN/9IhJUFFS8RvvefVTdSev1WmPEYCTkyLCitKDTelVM
         rlxMHxrNYBcLQd1lfYJKWV917maVXhTAJeqN0=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Phil Turmel <philip@turmel.org>
Subject: Re: [BUG, Regression, bisected] USB mouse causes bug on 1st insert, ignored on 2nd insert, lsusb stuck at usbdev_open
Date: Mon, 20 Sep 2010 21:35:41 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4; KDE/4.4.5; i686; ; )
Cc: Guillaume Chazarain <guichaz@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Alan Ott <alan@signal11.us>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org
References: <4C96B9DB.8030403@turmel.org>
In-Reply-To: <4C96B9DB.8030403@turmel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009202135.41833.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 20 września 2010 o 03:33:15 Phil Turmel wrote:
> A new regression was introduced between -rc3 and -rc4:
> 
> The USB mouse I use with my laptop is causing a BUG when inserted.  It
> works at that point, but if removed and re-inserted, it is ignored.  Also,
> after the 2nd insert, other USB devices (like my thumb drive) are also
> ignored.
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=18892
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
