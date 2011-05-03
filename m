Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1ECReB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:34:01 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54008 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab1ECRd7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:33:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VuetSgOM2xm3PvAnDlh8gNKxvkKc3fR0FY+68iJtwolOSiWpGLitO5J+N8SAD/Ache
         YxAEDfKhPsbRi8O50O2HVrZjC9ymBzoV6/YLT85/h8/x3Yzp8/eVayV6d1vGxigKVWRZ
         u7qBb16EWXuTda8wRspyrBk1LfL8Fy54EAdUU=
MIME-Version: 1.0
In-Reply-To: <710D4D6CE160654C87478D18385BB9971BE3FDCA46@MDC-MAIL-CMS01.ubisoft.org>
References: <1304264799.2833.82.camel@localhost>
	<1304364912-15444-1-git-send-email-agimenez@sysvalve.es>
	<1304370274.2833.192.camel@localhost>
	<20110503165751.GA6566@bart.evergreen.loc>
	<710D4D6CE160654C87478D18385BB9971BE3FDCA46@MDC-MAIL-CMS01.ubisoft.org>
Date: Tue, 3 May 2011 18:33:58 +0100
Message-ID: <BANLkTi=W5HTLDa-UEvk4TefP3FyOvphxew@mail.gmail.com>
Subject: Re: [PATCH] ipheth.c: Enable IP header alignment
From: Paul McEnery <pmcenery@gmail.com>
To: David Hill <david.hill@ubisoft.com>
Cc: =?ISO-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dgiagio@gmail.com" <dgiagio@gmail.com>,
        "dborca@yahoo.com" <dborca@yahoo.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "open list:USB SUBSYSTEM" <linux-usb@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 May 2011 18:18, David Hill <david.hill@ubisoft.com> wrote:
>
> Maybe I can help on this part.
>
> Git ?
>
> I'm using ubuntu natty ... The part  I'm not sure of is , do I patch ubuntu's kernel or I start from scratch?
>

If we can get the patch committed to the Github ipheth repo, I'll
package it in my Ubuntu PPA. You can then simply install ipheth-dkms
which allow it to replace the in-tree module for testing...

I unfortunately cannot test either, since I no longer have an iPhone.

Paul.
