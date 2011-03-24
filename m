Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab1CXRkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:40:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52594 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab1CXRkT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:40:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=AazS43C81eydvET3cT+dmf/unXBdjc/TQY3Q5V4XV0ZuFM3QesR9IEt+QlQtBzzzbO
         4SiWt5CTnD0MdbFkz/VWOOZJbudUXOxrEEG17r2cNXBa/OYT4Pq4e7OIgI4CA7zwPYGx
         XpJcT5APdgTTpkDC2h+Ouwa2Gmz0tNA3tQ57c=
MIME-Version: 1.0
In-Reply-To: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 24 Mar 2011 13:39:56 -0400
X-Google-Sender-Auth: mqk1nxRdLbQLBqK_UMgfyhaX_YM
Message-ID: <AANLkTim3kMCE=LhCRcUDif8ENSA-E-_Xga5cDSYs0x25@mail.gmail.com>
Subject: Re: [RFC PATCHv2 0/4] Support for OTP memory
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 11:21, Jamie Iles wrote:
> Following some feedback from Greg, I've updated this series to be more
> of a generic OTP layer.  Everything is now registered under the "otp"
> bus and I've also converted the blackfin OTP driver to use this
> framework (which is the only current OTP driver I could find).

really, i'm the only one who wrote a driver ?  that's boring.

i guess this isnt trying to handle OTP stuff that exists in the MTD
layer already ?

> Mike, I wasn't 100% sure how big the blackfin OTP is but I found a
> datasheet talking about 64KB so I've assumed that for now.

the datasheets say 64K *bits* :).  i think all our datasheets tend to
use bits rather than bytes because they're stupid and bigger numbers
always means better parts !

but yes, on-chip OTP on all relevant Blackfin parts today are 8KiB in
size.  0x200 128bit pages is how things are organized.
-mike
