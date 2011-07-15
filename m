Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965452Ab1GOKzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 06:55:08 -0400
Received: from server655-han.de-nserver.de ([85.158.177.45]:49000 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964982Ab1GOKzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 06:55:07 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jul 2011 06:55:06 EDT
Message-ID: <4E201AFB.1020105@profihost.ag>
Date: Fri, 15 Jul 2011 12:48:27 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: iSCSI initiator
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

i'm trying to create a new iscsi based storage system using the "new" 
LIO implementation.

I'm just wondering which module / software should be used on client side.

Until now we're using Open-iSCSI but for example on 
http://linux-iscsi.org/wiki/Core-iSCSI you read that Open-iSCSI is slow 
and old and you should use Core-iSCSI but Core-ISCSI is also at least 5 
years old and doesn't even compile against an actual kernel.

I'm now totally confused what the the up2date way for iSCSI under Linux is.

I'm NOT ON list so please CC me.

Greets
Stefan
