Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0DMXOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 19:14:05 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:45996 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab0DMXOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 19:14:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=Zb0HCB1BpGjeSJiuESgjdDmMMyATH/v4kAE+YRXRFMxJ4Osc9h21Uh0jDyWvfLIBNs
         W0O20N5TBK8HXCPgC0D0ka61gSFJ9ZfVukUE5k8e5oe3DgAh/KV4Qmp7/WnenSS4EjV1
         EOGbDthRdh6qyfVNTdB8EjApb8cdp6fi5Ni/A=
MIME-Version: 1.0
From: Michal Suchanek <hramrach@centrum.cz>
Date: Wed, 14 Apr 2010 01:13:40 +0200
X-Google-Sender-Auth: 49b5cad28747e505
Message-ID: <y2qa5d587fb1004131613obfc84dc2yd862cd79d7a3b084@mail.gmail.com>
Subject: Parallel port LCD driver undocumented
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I was thinking about adding a LCD to my PC so I thought that the
panel.c driver which just went to 2.6.34 would be helpful.

The problem is there is no documentation. I can get quite detailed
documentation for at least some LCDs that are sold around here but
there is not enough documentation for the driver to determine if the
LCD in question would be compatible with the driver and with which
protocol.

Detailed explanation of the parameters would be appreciated. For
example, there are three parallel protocols supported but there is no
description of the difference between them.

Thanks

Michal
