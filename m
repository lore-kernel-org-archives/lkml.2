Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab0I3Pr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 11:47:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61735 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab0I3Prz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 11:47:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=JVPVwfRbK9HAMeruKwEMwXNLxA+sgyp56GU+rclISxP7fVyEvhV5ZVNwg46/osUnhI
         y/HE1beJknh13OJBVucp+odGDTQwLnf+K22VaUwte2Z3N2BkwOSyBfeS175YwyoBRRXA
         7zMXmdpDjFwr9H5wnadRuYzFXedXTjNOIOMP4=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bastien Nocera <hadess@hadess.net>
Subject: Re: [RESEND] [PATCH] Input: add appleir USB driver
Date: Thu, 30 Sep 2010 08:47:41 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6+; KDE/4.4.5; x86_64; ; )
Cc: "linux-input" <linux-input@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1285844276.26405.26.camel@cookie.hadess.net>
In-Reply-To: <1285844276.26405.26.camel@cookie.hadess.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009300847.43090.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bastien,

On Thursday, September 30, 2010 03:57:55 am Bastien Nocera wrote:
> This driver was originally written by James McKenzie, updated by
> Greg Kroah-Hartman, further updated by myself, with suspend support
> added.
> 
> More recent versions of the IR receiver are also supported through
> a patch by Alex Karpenko. The patch also adds support for the 2nd
> and 5th generation of the controller, and the menu key on newer
> brushed metal remotes.
> 
> Tested on a MacbookAir1,1
> 

There are no changes from the last time you sent it, right? I'll try
to get the driver in .37 but after that we should probably move it
over to the new IR infrastructure...

Thanks.

-- 
Dmitry
