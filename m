Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab2GKNiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:38:52 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54454 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab2GKNiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:38:50 -0400
MIME-Version: 1.0
Date: Wed, 11 Jul 2012 10:38:49 -0300
Message-ID: <CAP2AAQMvx5yxVRLN4AT_YdsFJAUDRgSNwzq0A3x8JyZgXKEjmw@mail.gmail.com>
Subject: Protocol handler using dev_add_pack
From: Jerry Yu <jerryy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am working on a kernel module to monitor all TCP packets. I created a protocol
handler with protocol code ETH_P_ALL to handle all incoming and outgoing
TCP packets. The code worked fine on 2.6.14 kernel, but in current 3.2.0-26
kernel, I am no longer able to get the TCP payload for outgoing packets.
The data in TCP payload section of skb->data are mainly 0x00. I am still
able to get incoming TCP packets' payloads though.

Is there any change in 3.2.0 or other early kernel versions that will cause
this issue?

Thanks,

Jerry
