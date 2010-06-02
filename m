Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab0FBHtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 03:49:43 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58806 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab0FBHtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 03:49:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=HKn/kiHgi1jzEjokLXPFZEwLeEDT1t3O+Sn5HkEP0XcgufJvgPDTNcGWBqhfl/iTF+
         HrDeNKxUg3uhd9Y3C3mDbfmQTee2BhC3Aedfd2m80VnkugXupv8uG4NCN94kWhMxho8A
         TiWad/1/h/pcVRUlX9j91wGoKB1WEbaijXLDc=
MIME-Version: 1.0
Date: Wed, 2 Jun 2010 15:49:41 +0800
Message-ID: <AANLkTikkZ91YlkFtRbitdddFIPAHxXjOn3enjN1UPXJo@mail.gmail.com>
Subject: Does iop13xx support cache coherent?
From: s ticket <smticket@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, everyone
     I am now doing some work on IOP13xx platform.
     It seems that there is a 'arch_is_coherent()' macro in arm
architecture, but only ixp23xx support it ?

     Does iop13xx support coherent and does arm-linux support it?

    Thx for advance.


                                   sticket
