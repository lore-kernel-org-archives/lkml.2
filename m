Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab0CVOiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:38:11 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:52024 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab0CVOiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:38:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=OkpTVBDSoCzHaNyjkfWgP9lAnE4Gt7uIWY7+xO5oBh8BLtH0D4iDOK4Xz5W0ikDic0
         wucOQRLAIeIUa4qN4LsaOHsC/aTHIeWUzWoNhKy+MZrY7ZCOpIVucikKFluZRT6+O05W
         lIFgSbYMhGAj24OGON5jF2sjB7+w9TQmciaTw=
MIME-Version: 1.0
Date: Mon, 22 Mar 2010 20:08:08 +0530
Message-ID: <facecd891003220738o7764b556x93efebb08b94663d@mail.gmail.com>
Subject: About source IP address of IGMP Join sent on loopback interface
From: preetham B <preetham.b79@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am running igmp daemon(igmp router side) and igmp host on same PC.
When the host joins on loopback interface, igmp daemon is expected to
receive the join report on loopback interface.
Here the join on loopback interface is not going outside the
PC(Outside Network).

Is it possible to receive join report (@ igmp daemon) with source IP
address as loopback interface address
in above explained setup?

When I run the host,  output of netstat command is as below:

#netstat -ng

IPv6/IPv4 Group Memberships
Interface       RefCnt Group
--------------- ------ ---------------------
lo              1      239.5.1.7   ==========> This is the group
joined on loopback
lo              1      224.0.0.1
eth0            1      224.0.0.1
eth0            1      239.5.5.6
eth0            1      239.5.5.7


Please cc me in the response

Regards,
Anupam
